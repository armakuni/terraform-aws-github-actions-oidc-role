variable "github_repository" {
  type        = string
  description = "The name of the Github repository to add the role for"
}

variable "github_owner" {
  type        = string
  description = "The Github user or organisation name that owns repository to add the role for"
}

variable "git_ref" {
  type        = string
  description = "The git refs for branches which can assume this role"
  default     = "refs/heads/main"
}

variable "oicd_provider_arn" {
  type        = string
  description = "The ARN of the Github Actions OIDC provider (if not provided, the module will use a data provider to find it)"
  default     = null
}

variable "policy_arn_list" {
  type        = list(string)
  default     = []
  description = "A list of policy ARNs to attach to the role (there are the AWS permissions that your Github Actions pipeline will have)"
}

variable "custom_policy" {
  type = object(
    {
      Version   = string
      Statement = list(any)
    }
  )
  default     = null
  description = "A custom policy to attach to your role if you want more fine grained permissions"
}
