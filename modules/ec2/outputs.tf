output "app" {
  value = aws_instance.app[*].id
}
/*output "app02" {
  value = aws_instance.app.1.id
}
output "ec2ip" {
  value = aws_instance.app[*].private_ip
}
output "ec2ip2" {
  value = aws_instance.app.1.private_ip
}*/
output "db" {
  value = aws_instance.sql.private_ip
}
output "cache" {
  value = aws_instance.cache.private_ip
}
output "mq" {
  value = aws_instance.memq.private_ip
}