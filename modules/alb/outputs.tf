output "alb-dns-name" {
  value = aws_lb.kiwi-dev-alb.dns_name
}
output "tg" {
  value = aws_lb_target_group.kiwi-dev-tg.arn
}
output "aws-alb" {
  value = aws_lb.kiwi-dev-alb.id
}