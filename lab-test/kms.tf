# Keys kms_ssm_parameter

resource "aws_kms_key" "kms_ssm_parameter" {
  description = "kms_ssm_parameter"
  is_enabled  = true
}
# kms_ssm_parameter Alias
resource "aws_kms_alias" "kms_ssm_parameter_alias" {
  name          = "alias/${var.service}-${var.aws_region}-kms_ssm_parameter"
  target_key_id = aws_kms_key.kms_ssm_parameter.key_id
}