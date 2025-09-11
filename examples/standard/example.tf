provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "sqs" {
  source = "./../../"

  name        = "sqs"
  environment = "test"
  label_order = ["name", "environment"]

  enabled                   = true
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  sqs_managed_sse_enabled   = true
  policy                    = data.aws_iam_policy_document.document.json

  create_queue_policy = true

  queue_policy_statements = {
    account = {
      sid = "AllowAllAccount"
      actions = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      ]
    }
  }

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
    actions = ["sqs:SendMessage"]
    resources = [
      format("arn:aws:sqs:eu-west-1:%s:test-clouddrove-sqs", data.aws_caller_identity.current.account_id)
    ]
  }
}
