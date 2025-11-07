output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "web_url" {
  description = "Website URL"
  value       = "http://${aws_instance.web_server.public_dns}"
}

