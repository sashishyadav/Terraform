variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "Iam_scripts-1"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic"
  default     = "key-rotation-topic-1"
}

variable "lambda_timeout" {
  description = "The timeout for the Lambda function in seconds"
  default     = 300
}

variable "lambda_memory_size" {
  description = "The memory size for the Lambda function in MB"
  default     = 128
}

variable "schedule_expression" {
  description = "The schedule expression for the CloudWatch Event Rule"
  default     = "rate(7 days)"
}
