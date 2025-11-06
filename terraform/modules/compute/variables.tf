variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "datadog_api_key" {
  description = "Datadog API key for Windows agent installation"
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog site (e.g., us5.datadoghq.com)"
  type        = string
  default     = "datadoghq.com"
}
