#module "okta-aws" {
#  count = 0
#  source = "./okta-aws"
#
#  aws_account_and_role_mapping = {
#    "578653720762" = {
#      account_alias      = "Ayush's",
#      role_name_suffixes = [
#        "CONSOLE-ACCESS"
#      ]
#    },
#    "121859831222" = {
#      account_alias      = "Joe's",
#      role_name_suffixes = [
#        "CONSOLE-ACCESS"
#      ]
#    },
#    "045712561016" = {
#      account_alias      = "Digvijay's",
#      role_name_suffixes = [
#        "CONSOLE-ACCESS"
#      ]
#    },
#  }
#}

module "aws-network" {
  source = "./aws-network"

  create_nat_gateway = false
  vpc_cidr_block = "10.2.0.0/20"
  tag_prefix = "joe"
  max_no_of_private_subnet = 3
  max_no_of_public_subnet = 2
}