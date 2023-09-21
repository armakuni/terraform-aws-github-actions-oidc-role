provider aws {}

module role {
  source = "../../"
  github_repo = "example-repo"
  github_org = "example-org"
  policy_arn_list = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  custom_policy = {
    Version = "2017-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = [
          "arn:aws:s3:::*"
        ]
      }

    ]
  }
}