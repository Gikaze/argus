output "srv_app_public_ip" {
  value = aws_instance.app.public_ip
}

output "srv_argus_public_ip" {
  value = aws_instance.argus.public_ip
}

output "srv_app_private_ip" {
  value = aws_instance.app.private_ip
}

output "srv_argus_private_ip" {
  value = aws_instance.argus.private_ip
}
