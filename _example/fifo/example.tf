provider "aws" {
  region = "eu-west-1"
}

module "sqs" {
  source = "./../../"

  name        = "sqs-fifo"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  fifo_queue                  = true
  content_based_deduplication = true
}
