variable "TF_VAR_AWS_REGION" {
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

# Database variables
variable "db_instance_class" {
  description = "The instance class for the RDS instances"
  type        = string
  default     = "db.t3.micro"
}

variable "TF_VAR_DB_NAME" {
  description = "The database name for the RDS MariaDB instance"
  type        = string
  sensitive   = true
}

variable "TF_VAR_DB_USER" {
  description = "The username for the RDS MariaDB instance"
  type        = string
  sensitive   = true
}
variable "TF_VAR_DB_MASTER_PASSWORD" {
  description = "The master password for the RDS MariaDB instance"
  type        = string
  sensitive   = true
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