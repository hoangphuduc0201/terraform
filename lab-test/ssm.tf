# SSM Parameter Store

resource "aws_ssm_parameter" "ECS_CLUSTER_FE_NAME" {
  name        = "ECS_CLUSTER_FE_NAME"
  description = "ECS_CLUSTER_FE_NAME"
  type        = "SecureString"
  value       = aws_ecs_cluster.cluster-fe.name
  key_id      = aws_kms_key.kms_ssm_parameter.arn
  overwrite   = "true"
}

resource "aws_ssm_parameter" "FE_SERVICE_NAME" {
  name        = "FE_SERVICE_NAME"
  description = "FE__SERVICE_NAME"
  type        = "SecureString"
  value       = aws_ecs_service.service-fe.name
  key_id      = aws_kms_key.kms_ssm_parameter.arn
  overwrite   = "true"
}

resource "aws_ssm_parameter" "ECS_CLUSTER_BE_NAME" {
  name        = "ECS_CLUSTER_BE_NAME"
  description = "ECS_CLUSTER_BE_NAME"
  type        = "SecureString"
  value       = aws_ecs_cluster.cluster-be.name
  key_id      = aws_kms_key.kms_ssm_parameter.arn
  overwrite   = "true"
}

resource "aws_ssm_parameter" "BE_SERVICE_NAME" {
  name        = "BE_SERVICE_NAME"
  description = "BE_SERVICE_NAME"
  type        = "SecureString"
  value       = aws_ecs_service.service-be.name
  key_id      = aws_kms_key.kms_ssm_parameter.arn
  overwrite   = "true"
}