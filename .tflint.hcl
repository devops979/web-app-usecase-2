plugin "aws" {
  enabled = true
  version = "0.24.1"  # Or the latest version
  source = "github.com/terraform-linters/tflint-ruleset-aws"
}


plugin "terraform" {
  enabled = true
  preset  = "recommended"
}


rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "aws_s3_bucket_versioning" {
  enabled = true
  message = "S3 buckets must have versioning enabled."
  check = {
    resource = "aws_s3_bucket"
    key      = "versioning"
    value    = "Enabled"
  }
}