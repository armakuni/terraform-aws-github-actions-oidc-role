data "aws_iam_openid_connect_provider" "oicd_provider" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_actions_role" {
  name        = "${var.github_repo}-github-actions"
  description = "Role for OIDC flow for ${var.github_repo} repo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
          }
        }
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.oicd_provider.arn
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_only_policy" {
  for_each   = toset(var.policy_arn_list)
  policy_arn = each.value
  role       = aws_iam_role.github_actions_role.name
}

resource "aws_iam_policy" "custom_policy" {
  count = var.custom_policy != null ? 1 : 0
  name   = "${var.github_repo}-github-actions-custom-policy"
  policy = jsonencode(var.custom_policy)
}

resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {
  count      = var.custom_policy != null ? 1 : 0
  policy_arn = aws_iam_policy.custom_policy[0].arn
  role       = aws_iam_role.github_actions_role.name
}