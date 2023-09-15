# Github Actions AWS OIDC Terraform Module

This module creates the required roles in AWS to authenticate GitHub modules with AWS via OIDC.

You provide you GitHub organisation/username and repository name as variables to the module.
It will create a role name `<repository name>-github-actions` which you can use to authenticate with AWS in your GitHub actions like so:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v3
  with:
    role-to-assume: arn:aws:iam::<aws account id>:role/<repository name>-github-actions
    role-session-name: aws-login
    aws-region: eu-west-3
```

<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.github_actions_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.read_only_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_openid_connect_provider.oicd_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | n/a | `string` | n/a | yes |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | n/a | `string` | n/a | yes |
| <a name="input_policy_arn_list"></a> [policy\_arn\_list](#input\_policy\_arn\_list) | n/a | `list(string)` | n/a | yes |
<!-- END_TF_DOCS -->
