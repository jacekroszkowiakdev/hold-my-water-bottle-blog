resource "aws_acm_certificate" "wordpress_ssl_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"


}

resource "aws_acm_certificate_validation" "cert_validation" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.wordpress_ssl_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.wordpress_cert_validation_record : record.fqdn]
}