resource "aws_codestarconnections_connection" "github" {
  name          = var.connection_name
  provider_type = "GitHub"

  tags = merge(
    {
      Name = var.connection_name
    },
    var.tags
  )
}