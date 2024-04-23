output "arn" {
  value       = module.sqs.*.arn
  description = "The ARN of the SQS queue"
}

output "tags" {
  value       = module.sqs.tags
  description = "A mapping of tags to assign to the sqs."
}
