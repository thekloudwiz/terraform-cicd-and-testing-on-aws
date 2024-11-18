# CodeStar Connection for GitHub v2
#checkov:skip=CKV2_AWS_21: "Ensure that CodeStar Connection is configured to use a codebuilding project"

# Create random secret for webhooks
resource "random_password" "webhook_secret" {
  for_each = local.github_pipelines

  length      = 32
  special     = true
  min_special = 2
  min_numeric = 2
  min_upper   = 2
  min_lower   = 2

  lifecycle {
    create_before_destroy = true
  }
}

# Create CodePipeline webhook
resource "aws_codepipeline_webhook" "github_webhook" {
  for_each = local.github_pipelines

  name            = "webhook-${each.value.name}"
  authentication  = "GITHUB_HMAC"
  target_action   = lookup(lookup(each.value.stages[0], "action")[0], "name", "")
  target_pipeline = aws_codepipeline.codepipeline[each.key].name

  authentication_configuration {
    secret_token = random_password.webhook_secret[each.key].result
  }

  filter {
    json_path = "$.ref"
    match_equals = try(
      "refs/heads/${each.value.stages[0].action[0].configuration.Branch}",
      "refs/heads/main"
    )
  }
  tags = merge(
    {
      Name = "webhook-${each.value.name}"
    },
    var.tags
  )
  lifecycle {
    precondition {
      condition     = length(each.value.name) <= 90
      error_message = "Webhook name prefix must be 90 characters or less"
    }
  }
}

# Create GitHub webhook
resource "github_repository_webhook" "github_webhook" {
  for_each = local.github_pipelines

  repository = try(
    split("/",
      each.value.stages[0].action[0].configuration.FullRepositoryId
    )[1],
    each.value.name
  )
  configuration {
    url          = aws_codepipeline_webhook.github_webhook[each.key].url
    content_type = "json"
    insecure_ssl = false
    secret       = random_password.webhook_secret[each.key].result
  }
  events = ["push", "pull_request"]

  depends_on = [
    aws_codepipeline_webhook.github_webhook,
    github_repository.repos # if you're creating repos in the same config
  ]
}