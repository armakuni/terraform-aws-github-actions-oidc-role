provider "aws" {}

data "aws_iam_openid_connect_provider" "oicd_provider" {
  url = "https://token.actions.githubusercontent.com"
}

module "role" {
  source = "../../"

  github_repository = "example-repo"
  github_owner      = "example-org"
  oicd_provider_arn = data.aws_iam_openid_connect_provider.oicd_provider.arn

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
        ],
        Condition = {
          "StringEquals" : {
            "s3:RequestObjectTag/TagName" : "TagValue"
          }
        }
      }
    ]
  }
}
