resource "aws_route53_zone" "public_zone" {
  name = var.domain
}

resource "aws_route53_record" "external-alb" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "*.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_alb.external-alb.dns_name
    zone_id                = aws_alb.external-alb.zone_id
    evaluate_target_health = true
  }
}