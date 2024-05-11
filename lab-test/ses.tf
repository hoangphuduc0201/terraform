resource "aws_ses_domain_identity" "default" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = var.domain
}

resource "aws_ses_domain_identity_verification" "ses_domain_verification" {
  domain     = aws_ses_domain_identity.default.id
  depends_on = [aws_route53_record.ses_domain_verification_record]
}

resource "aws_route53_record" "ses_domain_verification_record" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.default.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.default.verification_token]
}

resource "aws_route53_record" "ses_domain_verification_dkim_record" {
  count   = 3
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
