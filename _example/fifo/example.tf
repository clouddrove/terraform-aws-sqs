provider "aws" {
  region = "eu-west-1"
}

module "sqs" {
  source = "git::https://github.com/clouddrove/terraform-aws-sqs.git?ref=tags/0.12.1"

  name        = "sqs-fifo"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  fifo_queue                  = true
  content_based_deduplication = true
}
