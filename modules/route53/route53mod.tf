resource "aws_route53_zone" "route-zone" {
  name = "kiwi.com"
  vpc {
    vpc_id = var.vpc-id
  }
}
resource "aws_route53_record" "rone" {
  name    = "backend.kiwi.com"
  records = [var.bkend]
  zone_id = aws_route53_zone.route-zone.id
  type    = "A"
  ttl     = "300"
}
