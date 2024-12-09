data "aws_db_instance" "multi_az_mariadb" {
  db_instance_identifier = aws_db_instance.multi_az_mariadb.identifier
  depends_on = [aws_db_instance.multi_az_mariadb]
}

output "rds_endpoint" {
  value = data.aws_db_instance.multi_az_mariadb.endpoint
}

output "rds_db_name" {
  value = data.aws_db_instance.multi_az_mariadb.db_name
}

output "rds_username" {
  value = var.db_user
}

output "rds_password" {
  value = var.db_password
}

data "aws_subnet" "private_subnet_1_info" {
  id = aws_subnet.private_subnet_1.id
}

data "aws_subnet" "private_subnet_2_info" {
  id = aws_subnet.private_subnet_2.id
}

output "vpc_id_subnet_1" {
  value = data.aws_subnet.private_subnet_1_info.vpc_id
}

output "vpc_id_subnet_2" {
  value = data.aws_subnet.private_subnet_2_info.vpc_id
}