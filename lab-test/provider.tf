provider "aws" {
  region  = var.aws_region
  profile = var.profile
  version = "~> 3.0"
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = var.profile
  version = "~> 3.0"
}
provider "template" {
}