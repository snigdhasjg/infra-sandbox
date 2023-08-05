terraform {
  required_providers {
    aws = {
      version = "~> 4.50.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      environment = "sandbox"
      Owner = "Snigdhajyoti Ghosh"
    }
  }
}