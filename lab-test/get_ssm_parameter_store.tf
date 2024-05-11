data "aws_ssm_parameter" "DOCDB_USER" {
  name = "DOCDB_USER"
}
data "aws_ssm_parameter" "DOCDB_PASSWORD" {
  name = "DOCDB_PASSWORD"
}