resource "aws_db_instance" "multi_az_mariadb" {
  identifier              = "capstone-mariadb-instance"
  engine                  = "mariadb"
  engine_version          = "10.6"
  instance_class          = "db.t3.micro"          # db.t3.micro for better performance with Multi-AZ failover

  allocated_storage       = 2
  # Enable auto-scaling for storage
  max_allocated_storage   = 6
  username                = "admin"
  password                = var.db_master_password
  publicly_accessible     = false
  vpc_security_group_ids = aws_security_group.rds_mariadb_sg.id
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