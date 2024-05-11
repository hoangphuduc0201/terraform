data "aws_caller_identity" "iam_role_policy_attachment" {
}
# IAM Role Attachment for RDS Monitoring
 resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
   role       = aws_iam_role.rds_enhanced_monitoring.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
 }

 data "aws_iam_policy_document" "rds_enhanced_monitoring" {
   statement {
     actions = ["sts:AssumeRole"]
     effect  = "Allow"

     principals {
       type        = "Service"
       identifiers = ["monitoring.rds.amazonaws.com"]
     }
   }
 }

# IAM Role Attachment for ECS
resource "aws_iam_role_policy_attachment" "ec2_service_role" {
  role       = aws_iam_role.container_instance_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ec2_SSM_role" {
  role       = aws_iam_role.container_instance_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ec2_service_role2" {
  role       = aws_iam_role.container_instance_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_container_service_ses" {
  role       = aws_iam_role.container_instance_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_S3" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_CloudWatch" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_SSM" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
resource "aws_iam_role_policy_attachment" "ecs_task_role_ses" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_service_autoscaling_role" {
  role       = aws_iam_role.ecs_autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_iam_role_policy_attachment" "autoscaling_notification_accessrole" {
  role       = aws_iam_role.ecs_autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
}

resource "aws_iam_role_policy_attachment" "ecs_event_role" {
  role       = aws_iam_role.ecs_event_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_task_role" {
  role       = aws_iam_role.ecs_execution_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# Policy for Excution Role
resource "aws_iam_policy" "get_para_store_policy" {
  name        = "${var.service}-get_parameter_store_policy"
  path        = "/"
  description = "Get parameter store policy for excution role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs_execution_task_role_2" {
  role       = aws_iam_role.ecs_execution_task_role.name
  policy_arn = aws_iam_policy.get_para_store_policy.arn
}
# IAM Role Attachment for EC2 Profile
resource "aws_iam_role_policy_attachment" "ec2_role_S3" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "ec2_role_SSM" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_service_ses" {
  role       = aws_iam_role.ec2.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}
