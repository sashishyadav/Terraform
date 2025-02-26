variable "aws_region" {
  description = "The AWS region where resources will be created"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "Iam_scripts-1"
}

variable "lambda_handler" {
  description = "The handler for the Lambda function"
  default     = "lambda_function.lambda_handler"
}

variable "lambda_code_path" {
  description = "The path to the Lambda function code"
  default     = "function.zip"
}

variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function"
  default     = "python3.8"
}

variable "lambda_timeout" {
  description = "The timeout for the Lambda function"
  default     = 300
}

variable "lambda_memory_size" {
  description = "The memory size for the Lambda function"
  default     = 128
}

variable "lambda_source_dir" {
  description = "The source directory for the Lambda function code"
  default     = "path/to/your/lambda_function_directory"
}

variable "lambda_output_path" {
  description = "The output path for the Lambda function zip file"
  default     = "path/to/your/function.zip"
}

variable "schedule_expression" {
  description = "The schedule expression for the CloudWatch Event Rule"
  default     = "rate(7 days)"
}
