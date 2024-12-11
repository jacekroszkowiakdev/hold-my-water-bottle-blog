variable "region" {
    description = "The region to use for the project"
    type        = string
    default = "us-west-2"
 }

variable "az1" {
  description = "Primary availability zone"
  type        = string
  default     = "us-west-2a"
}

variable "az2" {
  description = "Secondary availability zone"
  type        = string
  default     = "us-west-2b"
}

variable "ec2_instance_type" {
  description = "The instance type for the ec2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name for the instance access"
  type        = string
  default = "vockey"
}

variable "db_instance_class" {
  description = "The instance class for the RDS instances"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The database name for the RDS MariaDB instance"
  type        = string
  default     = "wordpress"
}

variable "db_user" {
  description = "The username for the RDS MariaDB instance"
  type        = string
  default = "wordpressuser"
}
variable "db_password" {
  description = "The master password for the RDS MariaDB instance"
  type        = string
  default = "test2024test"
}

# Declare variables to stop "Warning: Value for undeclared variable" in the UI
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS Session Token"
  type        = string
}
