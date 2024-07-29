variable "aws_region" {
  description = "AWS Region, i.e. us-west-1"
  type        = string
  default     = "ap-southeast-2"
}

# Common variable names
variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "demo"
}

variable "company" {
  description = "Name of the company"
  type        = string
  default     = "copperleaf"
}

variable "app" {
  description = "Name of the application"
  type        = string
  default     = "webapp"
}

# Network
variable "vpc_cidr" {
  description = "CIDR block for the main VPC."
  type        = string
  default     = "172.80.0.0/16"
}

variable "subnet_public_a" {
  description = "CIDR block for the public subnet AZ A"
  type        = string
  default     = "172.80.10.0/24"
}

variable "subnet_public_b" {
  description = "CIDR block for the public subnet AZ B"
  type        = string
  default     = "172.80.20.0/24"
}

variable "subnet_private_a" {
  description = "CIDR block for the private subnet AZ A"
  type        = string
  default     = "172.80.30.0/24"
}

variable "subnet_private_b" {
  description = "CIDR block for the private subnet AZ B"
  type        = string
  default     = "172.80.40.0/24"
}

# ECR
variable "ecr_docker_image" {
  description = "Version number to be used by the task in the ECS cluster."
  type        = string
  default     = "latest"
}

# Notifications
variable "email_sns" {
  description = "Email address to use for SNS subscription."
  type        = string
  default     = "example@company.com"
}

# DNS
variable "dns_zone" {
  description = "Dns Zone Name."
  type        = string
  default     = "a-new-domain.com"
}

variable "dns_record" {
  description = "DNS Record to access Nginx."
  type        = string
  default     = "copperleaf-app"
}