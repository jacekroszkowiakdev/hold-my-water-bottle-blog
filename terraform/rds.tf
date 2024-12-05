resource "aws_db_instance" "multi_az_mariadb" {
  identifier              = "capstone-mariadb-instance"
  engine                  = "mariadb"
  engine_version          = "10.6"
  instance_class          = var.db_instance_class          # db.t3.micro for better performance with Multi-AZ failover

  allocated_storage       = 20
  # Enable auto-scaling for storage
  max_allocated_storage   = 40
  username                = "admin"
  password                = var.db_master_password
  publicly_accessible     = false
  vpc_security_group_ids = [aws_security_group.rds_mariadb_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name

 # Multi-AZ for failover
  multi_az                = true

  # Storage settings
  storage_type            = "gp2"
  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name        = "MyMariaDBInstance"
    Environment = "Production"
  }
}

resource "aws_db_instance" "replica1" {
  allocated_storage    = aws_db_instance.multi_az_mariadb.allocated_storage
  auto_minor_version_upgrade = true
  instance_class     = var.db_instance_class
  identifier = "capstone-mariadb-replica-instance"
  engine                = aws_db_instance.multi_az_mariadb.engine
  engine_version        = aws_db_instance.multi_az_mariadb.engine_version

  replicate_source_db   = aws_db_instance.multi_az_mariadb.id
  multi_az               = true
  port                  = 3306
  publicly_accessible    = false
  skip_final_snapshot    = false
  vpc_security_group_ids = [aws_db_instance.multi_az_mariadb.vpc_security_group_ids]

  depends_on = [aws_db_instance.multi_az_mariadb]
}