# IAM Role for RDS Monitoring
 resource "aws_iam_role" "rds_enhanced_monitoring" {
   name               = "${var.aws_region}-${var.service}"
   assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
 }

data "aws_iam_policy_document" "container_instance_ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_as_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_event_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
# IAM Role for EC2

resource "aws_iam_role" "container_instance_ec2" {
  name               = "${var.aws_region}-${var.service}-ContainerInstanceProfile"
  assume_role_policy = data.aws_iam_policy_document.container_instance_ec2_assume_role.json
}

resource "aws_iam_role" "ec2" {
  name               = "${var.aws_region}-${var.service}-InstanceProfile"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM Role for ECS Task

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.aws_region}-${var.service}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# IAM Role for ECS AS
resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.aws_region}-${var.service}-ecsASRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_as_assume_role.json
}

# IAM Role for ECS Event

resource "aws_iam_role" "ecs_event_role" {
  name               = "${var.aws_region}-${var.service}-ecsEventRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_event_role.json
}

# IAM Role for Activation

resource "aws_iam_role" "ssm-activation-role" {
  name               = "${var.aws_region}-${var.service}-SSM-ActivationRole-name"
  assume_role_policy = data.aws_iam_policy_document.ssm_activation_assume_role.json
}

data "aws_iam_policy_document" "ssm_activation_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM Role for ASG
resource "aws_iam_role" "autoscaling-role" {
  name               = "${var.aws_region}-${var.service}-EC2AutoScalingRole"
  assume_role_policy = data.aws_iam_policy_document.autoscaling-role.json
}

data "aws_iam_policy_document" "autoscaling-role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
  }
}
# IAM Role for ECS Execution Task
resource "aws_iam_role" "ecs_execution_task_role" {
  name               = "${var.aws_region}-${var.service}-ecs-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}