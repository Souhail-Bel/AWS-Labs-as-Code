terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
  # null makes provider fall back to the real AWS endpoint
  endpoint = var.use_floci ? var.floci_endpoint : null
}

provider "aws" {
  region = var.region

  # Floci accepts any creds
  access_key = var.use_floci ? "test" : null
  secret_key = var.use_floci ? "test" : null

  # Floci has no STS identity lookup
  skip_credentials_validation = var.use_floci
  skip_metadata_api_check     = var.use_floci
  skip_requesting_account_id  = var.use_floci

  # endpoint per serice the lab uses
  # Every service the lab uses needs its own endpoint.
  endpoints {
    # s3 = local.endpoint
  }
}
