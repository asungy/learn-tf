# To destroy state infrastructure, reinitialize terraform backend to use local
# (use `migrate-state` flag). Set bucket to `force_destroy = true`, run
# `terraform apply`. And then `terraform destroy` can be run without error.

# terraform {
#   backend "s3" {
#     access_key = "AKIAZRPVOCY6J47N5LVE"
#     secret_key = "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"
#
#     bucket = "bucket-56479b3d-64ca-4390-a163-371394418353"
#     key = "global/s3/terraform.tfstate"
#     region = "us-east-1"
#
#     dynamodb_table = "terraform-locks"
#     encrypt = true
#   }
# }
#
provider "aws" {
  region = "us-east-1"
  # Oh no! I spilled my keys!
  access_key = "AKIAZRPVOCY6J47N5LVE"
  secret_key = "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"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "bucket-56479b3d-64ca-4390-a163-371394418353"

  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
