output "sg_id" {
  description = "ID do Security Group"
  value       = aws_security_group.main.id
}

output "sg_name" {
  description = "Nome do Security Group"
  value       = aws_security_group.main.name
}
