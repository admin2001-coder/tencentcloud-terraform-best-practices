# COS backend config example
# Create a COS bucket and enable versioning.
# Keep this file free of secrets; credentials come from env/CI.

bucket  = "tfstate-example-prod-1234567890"
region  = "ap-singapore"
prefix  = "prod/network"
key     = "terraform.tfstate"
encrypt = true
