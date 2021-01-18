provider "aws" {
  region = "eu-west-1"
}

module "sqs" {
  source = "./../../"

  name        = "sqs-fifo"
  environment = "test"
  label_order = ["name", "environment"]

  enabled                     = true
  fifo_queue                  = true
  content_based_deduplication = true
}
