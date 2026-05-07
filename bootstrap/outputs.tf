# `output` exposes a calculated value after Terraform evaluates the module.
output "release_name" {
  # Describe the output so learners know why it exists.
  description = "Example release name assembled from input variables and locals."
  # `value` is the expression Terraform will print for this output.
  value = local.release_name
}

# This output shows the final merged tag map.
output "common_tags" {
  # Explain that these tags would be attached to resources in a real module.
  description = "Merged tag map that would be applied to real infrastructure."
  # Read the merged map from `locals` in main.tf.
  value = local.common_tags
}

# This output demonstrates using expressions to make a policy decision.
output "review_required" {
  # Explain the boolean rule being demonstrated.
  description = "Example policy decision: production requires at least one reviewer."
  # Return true only when environment is prod and the reviewers list is not empty.
  value = local.normalized_environment == "prod" && length(var.reviewers) > 0
}

# This output demonstrates checking a sensitive value without revealing it.
output "demo_api_token_was_set" {
  # Explain that we reveal only presence, not the token itself.
  description = "Shows whether a sensitive variable was provided without printing it."
  # `nonsensitive` is needed because Terraform treats derived sensitive values carefully.
  value = nonsensitive(var.demo_api_token) != ""
}