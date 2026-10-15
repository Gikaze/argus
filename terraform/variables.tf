variable "aws_region" {
  description = "AWS region (Frankfurt)"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "IP range of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "IP range of the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "my_ip_cidr" {
  description = "Admin public IP in /32 notation, the only source allowed to SSH into srv-argus"
  type        = string
}
