provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  version = "~> 1.14"
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "datasync-tool-demo-bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "datasync-tool-demo-bucket"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "datasync_tool_demo_table"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "datasync_tool_demo_table"
  }
}

terraform {
  backend "s3" {
    region = "us-east-1"
    key = "terraform.tfstate" # e.g. contosovpc
    bucket = "datasync-tool-demo-bucket"
    dynamodb_table = "datasync_tool_demo_table"
  }
}
