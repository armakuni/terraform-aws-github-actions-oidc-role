variable "github_repo" {
  type = string
}

variable "github_org" {
  type = string
}

variable "policy_arn_list" {
  type = list(string)
  default = []
}

variable "custom_policy" {
  type = object(
    {
      Version = string
      Statement = list(any)
    }
  )
  default = null
}