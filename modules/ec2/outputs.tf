output "app" {
  value = aws_instance.app[*].id
}
output "bkend" {
  value = aws_instance.backend.private_ip
}
