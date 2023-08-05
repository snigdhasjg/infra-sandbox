output "okta_saml_metadata_document" {
  value     = okta_app_saml.amazon_aws.metadata
  sensitive = true
}

output "okta_saml_metadata_url" {
  value = okta_app_saml.amazon_aws.metadata_url
}

output "aws_groups" {
  value = okta_group.user_groups_aws_account
}