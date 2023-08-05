resource "okta_app_saml" "amazon_aws" {
  label                 = "AWS console"
  auto_submit_toolbar   = false
  admin_note            = "Nothing just enjoy"
  enduser_note          = "Gives all aws account console access"
  preconfigured_app     = "amazon_aws"
#  authentication_policy = okta_app_signon_policy.aws_signon_policy.id
  skip_groups           = true
  skip_users            = true

  app_settings_json = <<JSON
{
  "appFilter": "okta",
  "awsEnvironmentType": "aws.amazon",
  "groupFilter": "aws_(?{{accountid}}\\d+)_(?{{role}}[a-zA-Z0-9+=,.@\\-_]+)",
  "joinAllRoles": false,
  "loginURL": "https://ap-south-1.console.aws.amazon.com/console/home",
  "roleValuePattern": "arn:aws:iam::$${accountid}:saml-provider/Okta,arn:aws:iam::$${accountid}:role/OKTA-$${role}",
  "sessionDuration": 3600,
  "useGroupMapping": true
}
JSON
}

#resource "okta_app_signon_policy" "aws_signon_policy" {
#  name        = "AWS Signon policy"
#  description = "Require two factors to access."
#}
#
#resource "okta_app_signon_policy_rule" "aws_signon_policy_rule" {
#  policy_id                   = okta_app_signon_policy.aws_signon_policy.id
#  name                        = "Password must + MFA"
#  priority                    = 1
#  re_authentication_frequency = "PT2H"
#
#  constraints = [
#    jsonencode({
#      knowledge = {
#        reauthenticateIn = "PT2H"
#        types            = [
#          "password"
#        ]
#      },
#      possession = {
#        deviceBound = "REQUIRED"
#      }
#    })
#  ]
#}

resource "okta_group" "user_groups_aws_account" {
  for_each    = flatten(var.aws_account_and_role_mapping)

  name        = "aws_${each.key}_${each.value.role_name_suffixes[0]}"
  description = "Controls ${each.value.account_alias} AWS account access"
  skip_users  = true
}

resource "okta_app_group_assignment" "aws_access_group_assignment_to_app" {
  for_each = okta_group.user_groups_aws_account

  app_id   = okta_app_saml.amazon_aws.id
  group_id = each.value.id
}


