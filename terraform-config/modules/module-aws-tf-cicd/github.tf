# Instructions: Dynamically create GitHub Repos

# First, check if repository exists
data "github_repository" "existing_repos" {
  for_each = var.github_repos == null ? {} : var.github_repos
  name     = each.value.repository_name
}

# Create a GitHub repository for each name in the list
resource "github_repository" "repos" {
  for_each = var.github_repos == null ? {} : var.github_repos

  name        = each.value.repository_name
  description = each.value.description
  visibility  = each.value.visibility

  lifecycle {
    create_before_destroy = true
  }

  # Optional repository features
  has_issues   = true
  has_projects = true
  has_wiki     = true

  # GitHub does not have a direct equivalent of tags in CodeCommit,
  # so you may consider adding them as topics.
  # topics = [for tag, _ in each.value.tags : tag]

  #checkov:skip=CKV_GIT_1:Repository needs to be public for demonstration purposes
  #checkov:skip=CKV2_GIT_1:Branch protection is handled separately
}