# Data source to get the Route 53 hosted zone ID
data "aws_route53_zone" "selected" {
  name = var.domain_name
}
# Create an alias record pointing to the LB
resource "aws_route53_record" "webapp_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"
  # ttl     = 60 # Commented out since we are using lb
  # records = [aws_instance.web.public_ip]

  alias {
    name                   = aws_lb.webapp_lb.dns_name
    zone_id                = aws_lb.webapp_lb.zone_id
    evaluate_target_health = true
  }
}