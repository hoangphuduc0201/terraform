# DocDB Subnet Group
resource "aws_docdb_subnet_group" "sg" {
  name        = "${var.service}-docdb-subnet-group"
  description = "${var.service}-docdb-subnet-group"
  subnet_ids  = aws_subnet.datastore.*.id

  tags = {
    Name        = "${var.service}-docdb"
    service     = "${var.service}"
  }
}

# DocDB Parameter Group
resource "aws_docdb_cluster_parameter_group" "docdb" {
  name        = "${var.service}-docdb-group"
  family      = var.docdb["parameter_group_family"]
  description = "${var.service}-docdb-group"
  parameter {
    name  = "tls"
    value = "disabled"
  }
}

# DocDB Cluster
resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = "${var.service}-${var.docdb["cluster_identifier"]}"
  engine                          = var.docdb["engine"]
  master_username                 = data.aws_ssm_parameter.DOCDB_USER.value
  master_password                 = data.aws_ssm_parameter.DOCDB_PASSWORD.value
  port                            = var.docdb["database_port"]
  db_subnet_group_name            = aws_docdb_subnet_group.sg.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb.name
  backup_retention_period         = var.docdb["backup_retention_period"]
  preferred_backup_window         = var.docdb["preferred_backup_window"]
  skip_final_snapshot             = var.docdb["skip_final_snapshot"]
  vpc_security_group_ids          = [aws_security_group.docdb-sg.id]
  availability_zones              = var.availability_zones
}

# DocDB Instance

resource "aws_docdb_cluster_instance" "cluster_instances" {
  identifier                 = "${var.service}-${var.docdb["database_identifier"]}"
  cluster_identifier         = aws_docdb_cluster.docdb.id
  engine                     = var.docdb["engine"]
  instance_class             = var.docdb["instance_type"]
  apply_immediately          = var.docdb["apply_immediately"]
  auto_minor_version_upgrade = var.docdb["auto_minor_version_upgrade"]
  promotion_tier             = var.docdb["promotion_tier"]
}