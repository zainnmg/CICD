variable "app_name" {
  description = "Short name of the application or service."
  type        = string
  default     = "ci-cd-lab"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.app_name))
    error_message = "Use lowercase letters, numbers, and hyphens only."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], lower(var.environment))
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "Example non-secret config. This lab does not connect to AWS."
  type        = string
  default     = "eu-west-2"
}

variable "image_tag" {
  description = "Example release or image tag that a pipeline might pass in."
  type        = string
  default     = "local"
}

variable "reviewers" {
  description = "People or teams expected to inspect a production change."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Example map variable for labels you would put on real resources."
  type        = map(string)
  default     = {}
}

variable "demo_api_token" {
  description = "Example sensitive value. Pass with TF_VAR_demo_api_token, not in a committed tfvars file."
  type        = string
  default     = ""
  sensitive   = true
}