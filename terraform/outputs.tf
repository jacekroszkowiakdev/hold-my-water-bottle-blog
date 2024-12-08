data "aws_db_instance" "multi_az_mariadb" {
  db_instance_identifier =  aws_db_instance.multi_az_mariadb.identifier
}

output "rds_endpoint" {
  value = trimspace(data.aws_db_instance.multi_az_mariadb.endpoint)
  }

output "rds_db_name" {
  value = trimspace(data.aws_db_instance.multi_az_mariadb.db_name)
  sensitive = true
}
output "rds_username" {
  value = trimspace(var.db_user)
  sensitive = true
}
output "rds_password" {
  value     = trimspace(var.db_password)
  sensitive = true
}
