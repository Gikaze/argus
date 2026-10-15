# Firewall of srv-app (the business server)
resource "aws_security_group" "app" {
  name        = "argus-app-sg"
  description = "srv-app: web portal and system metrics"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Web portal for users"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH, open on purpose to demonstrate attack detection (keys only + fail2ban)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "node_exporter, only from the monitoring server"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.argus.id]
  }

  egress {
    description = "Outbound: system updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "argus-app-sg" }
}

# Firewall of srv-argus (the monitoring server)
resource "aws_security_group" "argus" {
  name        = "argus-monitoring-sg"
  description = "srv-argus: nothing exposed, SSH from the admin only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from the admin IP only (Grafana is reached through an SSH tunnel)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "Outbound: scraping srv-app, sending alerts, updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "argus-monitoring-sg" }
}
