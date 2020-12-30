provider "aws" {
  region = "eu-west-1"
}

module "sqs" {
  source = "./../../"

  name        = "sqs-fifo"
  repository  = "https://registry.terraform.io/modules/clouddrove/sqs/aws/0.14.0"
  environment = "test"
  label_order = ["name", "environment"]

  fifo_queue                  = true
  content_based_deduplication = true
}
