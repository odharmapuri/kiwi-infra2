output "sn1" {
  value = aws_subnet.sn1.id
}
output "sn2" {
  value = aws_subnet.sn2.id
}
output "app-sg" {
  value = aws_security_group.app-sg.id
}
output "alb-sg" {
  value = aws_security_group.alb-sg.id
}
output "backend-sg" {
  value = aws_security_group.backend-sg.id
}
output "vpc-id" {
  value = aws_vpc.kiwi-vpc.id
}