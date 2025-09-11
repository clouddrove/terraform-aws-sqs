# Module      : SQS
# Description : Terraform SQS module outputs.
output "id" {
  value       = join("", aws_sqs_queue.default.*.id)
  description = "The URL for the created Amazon SQS queue."
}

output "arn" {
  value       = join("", aws_sqs_queue.default.*.arn)
  description = "The ARN of the SQS queue."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}

output "queue_policy_document" {
  description = "The generated IAM policy document for the SQS queue"
  value       = try(data.aws_iam_policy_document.this[0].json, null)
}

output "queue_policy" {
  description = "The policy attached to the SQS queue"
  value       = try(aws_sqs_queue_policy.this[0].policy, null)
}

output "queue_with_policy_url" {
  description = "The URL of the SQS queue with the attached policy"
  value       = try(aws_sqs_queue_policy.this[0].queue_url, null)
}
