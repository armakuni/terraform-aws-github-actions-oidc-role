provider "aws" {}

module "role" {
  source = "../../"

  github_repository = "example-repo"
  github_owner      = "example-org"
}
