resource "aws_route53_zone" "route-zone" {
  name = "kiwi.com"
  vpc {
    vpc_id = var.vpc-id
  }
}
resource "aws_route53_record" "rone" {
  name    = "db.kiwi.com"
  records = [var.db]
  zone_id = aws_route53_zone.route-zone.id
  type    = "A"
  ttl     = "300"
}
resource "aws_route53_record" "rtwo" {
  name    = "cache.kiwi.com"
  records = [var.cache]
  zone_id = aws_route53_zone.route-zone.id
  type    = "A"
  ttl     = "300"
}
resource "aws_route53_record" "rthree" {
  name    = "mq.kiwi.com"
  records = [var.mq]
  zone_id = aws_route53_zone.route-zone.id
  type    = "A"
  ttl     = "300"
}