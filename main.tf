## Managed By : CloudDrove
## Description : This Script is used to create SQS resource on AWS for managing queue.
## Copyright @ CloudDrove. All Right Reserved.**

#Module      : label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  attributes  = var.attributes
  label_order = var.label_order
}

# Module      : SQS
# Description : Terraform module to create SQS resource on AWS for managing queue.
#tfsec:ignore:aws-sqs-enable-queue-encryption
resource "aws_sqs_queue" "default" {
  count = var.enabled ? 1 : 0

  name                              = var.fifo_queue ? format("%s.fifo", module.labels.id) : module.labels.id
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  policy                            = var.policy
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  redrive_policy                    = var.redrive_policy
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  tags                              = module.labels.tags
}


data "aws_partition" "current" {}

data "aws_iam_policy_document" "this" {
  count = var.enabled && var.create_queue_policy ? 1 : 0

  source_policy_documents   = var.source_queue_policy_documents
  override_policy_documents = var.override_queue_policy_documents

  dynamic "statement" {
    for_each = var.queue_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, [aws_sqs_queue.default[0].arn])
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

# --------------------------------
# Resource    : SQS Queue Policy
# Description : Attaches policy to the queue
# --------------------------------
resource "aws_sqs_queue_policy" "this" {
  count = var.enabled && var.create_queue_policy ? 1 : 0

  queue_url = aws_sqs_queue.default[0].url
  policy    = data.aws_iam_policy_document.this[0].json
}