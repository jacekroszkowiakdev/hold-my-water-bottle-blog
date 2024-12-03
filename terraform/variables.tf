variable "region" {
    description = "The region to use for the project"
    type        = string
    default = "eu-central-1"
 }

variable "az1" {
  description = "Primary availability zone"
  type        = string
  default     = "eu-central-1a"
}

variable "az2" {
  description = "Secondary availability zone"
  type        = string
  default     = "eu-central-1b"
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