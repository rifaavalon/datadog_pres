output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_instance.app[*].id
}

output "instance_private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.app[*].private_ip
}

output "instance_public_ips" {
  description = "List of public IP addresses"
  value       = aws_instance.app[*].public_ip
}

output "security_group_id" {
  description = "ID of the instance security group"
  value       = aws_security_group.instance.id
}

output "windows_instance_id" {
  description = "ID of the Windows instance"
  value       = aws_instance.windows.id
}

output "windows_instance_public_ip" {
  description = "Public IP of the Windows instance"
  value       = aws_instance.windows.public_ip
}

output "windows_instance_private_ip" {
  description = "Private IP of the Windows instance"
  value       = aws_instance.windows.private_ip
}
