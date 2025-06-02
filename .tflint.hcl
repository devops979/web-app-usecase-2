plugin "aws" {
  enabled = true
  version = "0.40.0"  # Or the latest version
  source = "github.com/terraform-linters/tflint-ruleset-aws"
}


plugin "terraform" {
  enabled = true
  preset  = "recommended"
}


rule "terraform_deprecated_interpolation" {
  enabled = true
}


