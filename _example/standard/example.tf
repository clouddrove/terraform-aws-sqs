provider "aws" {
  region = "eu-west-1"
}

module "sqs" {
  source = "git::https://github.com/clouddrove/terraform-aws-sqs.git?ref=tags/0.12.1"

  name        = "sqs"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  policy                    = data.aws_iam_policy_document.document.json
}

data "aws_iam_policy_document" "document" {
  version = "2012-10-17"
  statement {
    sid    = "First"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:eu-west-1:xxxxxxxxx:test-sqs-clouddrove"]
  }
}