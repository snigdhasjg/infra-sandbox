variable "aws_account_and_role_mapping" {
  description = "AWS account role mapping"

  type = map(object({
    account_alias      = string,
    role_name_suffixes = list(string)
  }))
}