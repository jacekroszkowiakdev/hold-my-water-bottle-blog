resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "wordpress_dns" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.wordpress_alb.dns_name
    zone_id                = aws_lb.wordpress_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wordpress_cert_validation_record" {
  for_each = { for d in aws_acm_certificate.wordpress_ssl_cert.domain_validation_options : d.domain_name => d }

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 300
}