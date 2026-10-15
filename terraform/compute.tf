# Latest official Ubuntu 24.04 LTS image, published by Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Admin SSH key, uploaded to AWS
resource "aws_key_pair" "admin" {
  key_name   = "argus-admin"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

# Business server: web portal
resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.admin.key_name

  # IMDSv2 only: protects the instance metadata from SSRF attacks
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 15
    encrypted   = true
  }

  tags = { Name = "srv-app" }
}

# Monitoring server: Prometheus, Grafana, Alertmanager (needs ~2 GB of RAM)
resource "aws_instance" "argus" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.argus.id]
  key_name               = aws_key_pair.admin.key_name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 20
    encrypted   = true
  }

  tags = { Name = "srv-argus" }
}
