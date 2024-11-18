# Create a local for GitHub pipelines
locals {
  github_pipelines = {
    for k, v in var.codepipeline_pipelines : k => v
    if can(regex("CodeStarSourceConnection", lookup(lookup(v.stages[0], "action")[0], "provider", "")))
  }
}