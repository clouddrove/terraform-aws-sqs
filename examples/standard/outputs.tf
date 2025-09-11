output "arn" {
  value       = module.sqs.*.arn
  description = "The ARN of the SQS queue."
}

output "tags" {
  value       = module.sqs.tags
  description = "A mapping of tags to assign to the alb."
}

output "queue_policy_document" {
  value       = module.sqs.queue_policy_document
  description = "Policy document generated inside the SQS module"
}

output "queue_policy" {
  value       = module.sqs.queue_policy
  description = "Policy attached to the SQS queue"
}

output "queue_with_policy_url" {
  value       = module.sqs.queue_with_policy_url
  description = "Queue URL with attached policy"
}