############################################
# DB Subnet Group
############################################
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

############################################
# RDS Instance
############################################
resource "aws_db_instance" "this" {
  identifier             = "${var.project_name}-db"
  allocated_storage      = 20

  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  deletion_protection    = false   # Recommended for dev environment
  multi_az               = false   # Can be enabled later if needed

  tags = {
    Name = "${var.project_name}-db"
  }
}
