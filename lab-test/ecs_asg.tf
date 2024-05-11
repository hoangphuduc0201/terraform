# AutoScaling Launch Configuration
data "template_file" "userdata-fe" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    cluster_name = aws_ecs_cluster.cluster-fe.name
    aws_region   = var.aws_region
  }
}

resource "aws_launch_configuration" "ecs_cluster_fe" {
  name_prefix                 = "${var.service}-cluster-fe-conf-"
  instance_type               = var.ecs["instance_type"]
  image_id                    = data.aws_ami.amazon_linux.id
  iam_instance_profile        = aws_iam_instance_profile.container_instance.name
  associate_public_ip_address = var.ecs["associate_public_ip_address"]
  security_groups             = [aws_security_group.fe-ec2-sg.id]
  user_data                   = data.template_file.userdata-fe.rendered
  key_name                    = var.ecs["key_name"]

  root_block_device {
    volume_type           = var.ecs["volume_type"]
    volume_size           = var.ecs["volume_size"]
    delete_on_termination = var.ecs["delete_on_termination"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "userdata-be" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    cluster_name = aws_ecs_cluster.cluster-be.name
    aws_region   = var.aws_region
  }
}
resource "aws_launch_configuration" "ecs_cluster_be" {
  name_prefix                 = "${var.service}-cluster-be-conf-"
  instance_type               = var.ecs["instance_type"]
  image_id                    = data.aws_ami.amazon_linux.id
  iam_instance_profile        = aws_iam_instance_profile.container_instance.name
  associate_public_ip_address = var.ecs["associate_public_ip_address"]
  security_groups             = [aws_security_group.be-ec2-sg.id]
  user_data                   = data.template_file.userdata-be.rendered
  key_name                    = var.ecs["key_name"]

  root_block_device {
    volume_type           = var.ecs["volume_type"]
    volume_size           = var.ecs["volume_size"]
    delete_on_termination = var.ecs["delete_on_termination"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# AutoScaling Group
resource "aws_autoscaling_group" "ecs_cluster_fe" {
  name                 = "${var.service}-cluster-fe"
  vpc_zone_identifier  = aws_subnet.public.*.id
  min_size             = var.ecs["min_size"]
  max_size             = var.ecs["max_size"]
  desired_capacity     = var.ecs["desired_capacity"]
  launch_configuration = aws_launch_configuration.ecs_cluster_fe.name
  health_check_type    = var.ecs["health_check_type"]
  termination_policies = ["OldestLaunchConfiguration", "NewestInstance"]
  enabled_metrics      = ["GroupStandbyInstances", "GroupTotalInstances", "GroupPendingInstances", "GroupTerminatingInstances", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupMinSize", "GroupMaxSize"]
  default_cooldown     = "3600"

  tag {
    key                 = "Name"
    value               = "${var.service}-ecs-fe-host"
    propagate_at_launch = true
  }
  tag {
    key                 = "service"
    value               = var.service
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [desired_capacity]
  }
}

resource "aws_autoscaling_group" "ecs_cluster_be" {
  name                 = "${var.service}-cluster-be"
  vpc_zone_identifier  = aws_subnet.public.*.id
  min_size             = var.ecs["min_size"]
  max_size             = var.ecs["max_size"]
  desired_capacity     = var.ecs["desired_capacity"]
  launch_configuration = aws_launch_configuration.ecs_cluster_be.name
  health_check_type    = var.ecs["health_check_type"]
  termination_policies = ["OldestLaunchConfiguration", "NewestInstance"]
  enabled_metrics      = ["GroupStandbyInstances", "GroupTotalInstances", "GroupPendingInstances", "GroupTerminatingInstances", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupMinSize", "GroupMaxSize"]
  default_cooldown     = "3600"

  tag {
    key                 = "Name"
    value               = "${var.service}-ecs-be-host"
    propagate_at_launch = true
  }

  tag {
    key                 = "service"
    value               = var.service
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [desired_capacity]
  }
}
