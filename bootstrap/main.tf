# `terraform` configures Terraform itself rather than your infrastructure.
terraform {
  # `required_version` protects you from running this lab with an older Terraform version.
  required_version = ">= 1.5"
}

# `locals` are named expressions you can reuse inside this Terraform module.
locals {
  # `lower(...)` normalizes input so `Prod`, `PROD`, and `prod` behave the same.
  normalized_environment = lower(var.environment)
  # This builds one readable release name from several variables.
  release_name = "${var.app_name}-${local.normalized_environment}-${var.image_tag}"

  # `merge(...)` combines the user-provided tags with required standard tags.
  common_tags = merge(
    # `var.tags` is the flexible map supplied by the user or tfvars file.
    var.tags,
    # This inline map contains tags the module always wants to include.
    {
      # Store the application name as a tag-like value.
      app = var.app_name
      # Store the normalized environment as a tag-like value.
      environment = local.normalized_environment
      # Record that Terraform would manage the resources if this created any.
      managed_by = "terraform"
    }
  )
}

# This lab intentionally creates no cloud resources.
# It lets you practise Terraform variables, validation, locals, and outputs safely.