terraform {
  required_version = ">= 1.1.0"

  backend "s3" {
    bucket  = "balastatefilebucket"
    key     = "tf/notify"
    region  = "us-east-1"
    encrypt = true

    # For Terraform versions below 1.1.0, you need to enable state locking by specifying use_lockfile = true
    # If you're using Terraform 1.1.0 or later, this is not needed as it's enabled by default
    # use_lockfile = true
  }
}
