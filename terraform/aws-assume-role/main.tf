terraform {
  required_providers {
    aws = {
      version = "~> 4.53.0"
    }
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::653268099225:user/pratik-1910"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  path               = "/aws-service-role/iam.amazonaws.com/"
  name               = "AWSServiceRoleForAmazonIAMUser"
  description        = "Allows Amazon IAM User to call AWS services on your behalf."
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
}

resource "aws_iam_role_policy_attachment" "github_actions_deny_policy_attachment" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "new_role" {
  value = aws_iam_role.this.arn
}