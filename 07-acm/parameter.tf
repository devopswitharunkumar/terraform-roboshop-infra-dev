resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.Project_Name}/${var.Environment}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.cert.arn
}
