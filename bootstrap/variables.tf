# `variable` declares an input that can be set by defaults, tfvars, CLI flags, or environment variables.
variable "app_name" {
  # `description` documents the variable for humans and generated docs.
  description = "Short name of the application or service."
  # `type = string` means this input must be plain text.
  type = string
  # `default` makes the variable optional when running Terraform.
  default = "ci-cd-lab"

  # `validation` adds a custom rule Terraform checks during plan/validate.
  validation {
    # `regex` enforces lowercase letters, numbers, and hyphens; `can` turns regex errors into false.
    condition = can(regex("^[a-z0-9-]+$", var.app_name))
    # Terraform shows this message when the condition is false.
    error_message = "Use lowercase letters, numbers, and hyphens only."
  }
}

# This input represents the environment a pipeline might target.
variable "environment" {
  # Tell the user what the variable means.
  description = "Deployment environment name."
  # Require the environment value to be a string.
  type = string

  # This validation limits the allowed environment names.
  validation {
    # `contains` checks the normalized environment against an allowed list.
    condition = contains(["dev", "staging", "prod"], lower(var.environment))
    # This message explains the allowed values if validation fails.
    error_message = "Environment must be dev, staging, or prod."
  }
}

# This is an example of non-secret config you might also store as a GitHub Actions variable.
variable "aws_region" {
  # The lab does not use AWS, but region is common in real CI/CD.
  description = "Example non-secret config. This lab does not connect to AWS."
  # A region is represented as text.
  type = string
  # Default to London.
  default = "eu-west-2"
}

# This input represents the version a pipeline would build or deploy.
variable "image_tag" {
  # Explain that this could come from CI/CD, such as a commit SHA.
  description = "Example release or image tag that a pipeline might pass in."
  # Tags are text values.
  type = string
  # `local` is a safe placeholder for local practice.
  default = "local"
}

# This input models people or teams who should review risky changes.
variable "reviewers" {
  # Explain what belongs in the list.
  description = "People or teams expected to inspect a production change."
  # `list(string)` means zero or more text values.
  type = list(string)
  # Empty list means no reviewers are configured by default.
  default = []
}

# This input demonstrates a map, which is useful for labels/tags.
variable "tags" {
  # Explain the map's real-world purpose.
  description = "Example map variable for labels you would put on real resources."
  # `map(string)` means key/value pairs where each value is text.
  type = map(string)
  # Empty map means no extra tags by default.
  default = {}
}

# This input demonstrates how Terraform handles sensitive values.
variable "demo_api_token" {
  # Tell users to pass this through the environment instead of committing it.
  description = "Example sensitive value. Pass with TF_VAR_demo_api_token, not in a committed tfvars file."
  # Secrets are often strings.
  type = string
  # Empty default lets the lab run without a real token.
  default = ""
  # `sensitive = true` hides the value from normal Terraform output.
  sensitive = true
}