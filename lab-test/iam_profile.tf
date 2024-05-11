# IAM Profile for EC2
resource "aws_iam_instance_profile" "ec2" {
  name = aws_iam_role.ec2.name
  role = aws_iam_role.ec2.name
}
# IAM Profile for ECS
resource "aws_iam_instance_profile" "container_instance" {
  name = aws_iam_role.container_instance_ec2.name
  role = aws_iam_role.container_instance_ec2.name
}