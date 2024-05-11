data "aws_caller_identity" "current" {}

# cloudwatch logs group
resource "aws_cloudwatch_log_group" "fe-log" {
  name              = "${var.service}-fe-log"
  retention_in_days = "180"
}
resource "aws_cloudwatch_log_group" "be-log" {
  name              = "${var.service}-be-log"
  retention_in_days = "180"
}

# ECS Cluster
resource "aws_ecs_cluster" "cluster-fe" {
  name = "${var.service}-${var.ecs["cluster_fe_name"]}"
}
resource "aws_ecs_cluster" "cluster-be" {
  name = "${var.service}--${var.ecs["cluster_be_name"]}"
}

# Task Definition
data "template_file" "task_definition_fe" {
  template = file("${path.module}/task-definition-fe.json.tpl")

  vars = {
    name           = var.container_fe["name"]
    image          = aws_ecr_repository.fe.repository_url
    version        = "v1"
    memory         = var.container_fe["memory"]
    cpu            = var.container_fe["cpu"]
    docker_port    = var.container_fe["docker_port"]
    awslogs-group  = aws_cloudwatch_log_group.fe-log.name
    awslogs-region = var.aws_region
  }
}
resource "aws_ecs_task_definition" "ecs_task_fe" {
  depends_on            = [data.template_file.task_definition_fe]
  family                = "${var.service}-ecs-task-fe"
  container_definitions = data.template_file.task_definition_fe.rendered
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

data "template_file" "task_definition_be" {
  template = file("${path.module}/task-definition-be.json.tpl")

  vars = {
    name           = var.container_be["name"]
    image          = aws_ecr_repository.be.repository_url
    version        = "v1"
    memory         = var.container_be["memory"]
    cpu            = var.container_be["cpu"]
    docker_port    = var.container_be["docker_port"]
    awslogs-group  = aws_cloudwatch_log_group.be-log.name
    awslogs-region = var.aws_region
  }
}
resource "aws_ecs_task_definition" "ecs_task_be" {
  depends_on            = [data.template_file.task_definition_be]
  family                = "${var.service}-ecs-task-be"
  container_definitions = data.template_file.task_definition_be.rendered
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

# ECS Service
resource "aws_ecs_service" "service-fe" {
  depends_on = [
    aws_ecs_task_definition.ecs_task_fe,
    aws_alb_listener.external-alb-insecure-listener
  ]
  name                               = "${var.service}-service-fe"
  cluster                            = aws_ecs_cluster.cluster-fe.id
  task_definition                    = aws_ecs_task_definition.ecs_task_fe.arn
  desired_count                      = var.container_fe["desired_count"]
  deployment_maximum_percent         = var.container_fe["deployment_maximum_percent"]
  deployment_minimum_healthy_percent = var.container_fe["deployment_minimum_healthy_percent"]
  health_check_grace_period_seconds  = "120"

  load_balancer {
    target_group_arn = aws_alb_target_group.fe.arn
    container_name   = var.container_fe["name"]
    container_port   = var.container_fe["docker_port"]
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}

resource "aws_ecs_service" "service-be" {
  depends_on = [
    aws_ecs_task_definition.ecs_task_be,
    aws_alb_listener.external-alb-insecure-listener
  ]
  name                               = "${var.service}-service-be"
  cluster                            = aws_ecs_cluster.cluster-be.id
  task_definition                    = aws_ecs_task_definition.ecs_task_be.arn
  desired_count                      = var.container_be["desired_count"]
  deployment_maximum_percent         = var.container_be["deployment_maximum_percent"]
  deployment_minimum_healthy_percent = var.container_be["deployment_minimum_healthy_percent"]
  health_check_grace_period_seconds  = "120"

  load_balancer {
    target_group_arn = aws_alb_target_group.be.arn
    container_name   = var.container_be["name"]
    container_port   = var.container_be["docker_port"]
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}