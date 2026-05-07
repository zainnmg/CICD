terraform {
  required_version = ">= 1.5"
}

locals {
  normalized_environment = lower(var.environment)
  release_name           = "${var.app_name}-${local.normalized_environment}-${var.image_tag}"

  common_tags = merge(
    var.tags,
    {
      app         = var.app_name
      environment = local.normalized_environment
      managed_by  = "terraform"
    }
  )
}

# This lab intentionally creates no cloud resources.
# It lets you practise Terraform variables, validation, locals, and outputs safely.