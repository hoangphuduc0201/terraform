# Security Group for external alb-sg 
resource "aws_security_group" "external-alb-sg" {
  name        = "${var.service}-external-alb-sg"
  description = "${var.service}-external-alb-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-external-alb-sg"
    service     = "${var.service}"
  }
}

# Security Group for EC2
resource "aws_security_group" "fe-ec2-sg" {
  name        = "${var.service}-fe-ec2-sg"
  description = "${var.service}-fe-ec2-sg"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.service}-fe-ec2-sg"
    service     = "${var.service}"
  }
}

resource "aws_security_group_rule" "allow-http-traffic" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.fe-ec2-sg.id
  source_security_group_id = aws_security_group.external-alb-sg.id
}

resource "aws_security_group_rule" "allow-fe-external-alb-sg" {
  description              = "allow-external-alb-port"
  type                     = "ingress"
  from_port                = 31000
  to_port                  = 61000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.fe-ec2-sg.id
  source_security_group_id = aws_security_group.external-alb-sg.id
}


# Security Group for be-sg
resource "aws_security_group" "be-ec2-sg" {
  name        = "${var.service}-be-ec2-sg"
  description = "${var.service}-be-ec2-sg"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-be-ec2-sg"
    service     = var.service
  }
}
resource "aws_security_group_rule" "allow-be-external-alb-sg" {
  security_group_id        = aws_security_group.be-ec2-sg.id
  description              = "allow-external-alb-port"
  type                     = "ingress"
  from_port                = 31000
  to_port                  = 61000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.external-alb-sg.id
}

# Security Group for docdb-sg
resource "aws_security_group" "docdb-sg" {
  name        = "${var.service}-docdb-sg"
  description = "${var.service}-docdb-sg"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-docdb-sg"
    service     = "${var.service}"
  }
}

resource "aws_security_group_rule" "allow-ec2-docdb-sg-rule" {
  security_group_id        = aws_security_group.docdb-sg.id
  description              = "allow-ec2"
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.fe-ec2-sg.id
}
resource "aws_security_group_rule" "allow-be-docdb-sg-rule" {
  security_group_id        = aws_security_group.docdb-sg.id
  description              = "allow-be"
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.be-ec2-sg.id
}
