data "aws_iam_openid_connect_provider" "oicd_provider" {
  count = var.oicd_provider_arn == null ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"
}

locals {
  oicd_provider_arn = (
    var.oicd_provider_arn != null
    ? var.oicd_provider_arn
    : data.aws_iam_openid_connect_provider.oicd_provider[0].arn
  )
}

resource "aws_iam_role" "this" {
  name        = "${var.github_repository}-github-actions"
  description = "Role for OIDC flow for ${var.github_repository} repo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.github_repository}:ref:${var.git_ref}"
          }
        }
        Effect = "Allow"
        Principal = {
          Federated = local.oicd_provider_arn
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy" {
  for_each   = toset(var.policy_arn_list)
  policy_arn = each.value
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "custom_policy" {
  count  = var.custom_policy != null ? 1 : 0
  name   = "${var.github_repository}-github-actions-custom-policy"
  policy = jsonencode(var.custom_policy)
}

resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {
  count      = var.custom_policy != null ? 1 : 0
  policy_arn = aws_iam_policy.custom_policy[0].arn
  role       = aws_iam_role.this.name
}
