##################
# aws_rds_cluster
##################
resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"
  availability_zones      = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  database_name           = "aurora_postgresql"
  master_username         = "foo"
  master_password         = "barbarbar"
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"

  vpc_security_group_ids = ["${aws_security_group.aurora_sg.id}"]
  storage_encrypted = false
  db_subnet_group_name = "${aws_db_subnet_group.aurora_db_subnet_group.id}"
  engine_version = "9.6.3"

  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_cluster_postgres96_parameter_group.id}"
}


############################
# aws_rds_cluster_instance
############################
resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = "${aws_rds_cluster.postgresql.id}"
  instance_class     = "db.r4.large"

  db_subnet_group_name = "${aws_db_subnet_group.aurora_db_subnet_group.id}"
  performance_insights_enabled = true
  engine = "aurora-postgresql"
  engine_version = "9.6.3"

  publicly_accessible = true

  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_postgres96_parameter_group.id}"
}