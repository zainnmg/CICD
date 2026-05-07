output "release_name" {
  description = "Example release name assembled from input variables and locals."
  value       = local.release_name
}

output "common_tags" {
  description = "Merged tag map that would be applied to real infrastructure."
  value       = local.common_tags
}

output "review_required" {
  description = "Example policy decision: production requires at least one reviewer."
  value       = local.normalized_environment == "prod" && length(var.reviewers) > 0
}

output "demo_api_token_was_set" {
  description = "Shows whether a sensitive variable was provided without printing it."
  value       = nonsensitive(var.demo_api_token) != ""
}