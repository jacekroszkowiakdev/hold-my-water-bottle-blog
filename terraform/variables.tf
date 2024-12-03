variable "vpc_id" {
  description = "The ID of the VPC to use for the project"
  type        = string
  default = "aws_vpc.capstone_vpc.id"
}

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