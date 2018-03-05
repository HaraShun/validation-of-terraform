##################
# DB Subnet Group
##################
resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora_db_subnet_group"
  subnet_ids = ["${aws_subnet.public_1a.id}", "${aws_subnet.public_1c.id}", "${aws_subnet.public_1d.id}"]

  tags {
    Name = "Aurora Postgres DB subnet group"
  }
}

#####################
# DB Parameter Group
#####################
resource "aws_db_parameter_group" "aurora_db_postgres96_parameter_group" {
  name        = "test-aurora-db-postgres96-parameter-group"
  family      = "aurora-postgresql9.6"
  description = "test-aurora-db-postgres96-parameter-group"
}

#########################
# Cluster Parameter Group
#########################
resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96_parameter_group" {
  name        = "test-aurora-postgres96-cluster-parameter-group"
  family      = "aurora-postgresql9.6"
  description = "test-aurora-postgres96-cluster-parameter-group"
}

################
# Security Group
################
resource "aws_security_group" "aurora_sg" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "rds"
  description = "Allow Aurora inbound traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["124.36.52.123/32"] 
    description = "modify comments"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "add new comments"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Aurora for Postgres"
  }
}