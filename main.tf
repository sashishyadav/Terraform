provider "aws" {
  region = "us-east-1"
}

# Create IAM Role and attach policies
resource "aws_iam_role" "invoke_lambda_role" {
  name = "Invoke-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sns_full_access" {
  role       = aws_iam_role.invoke_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_full_access" {
  role       = aws_iam_role.invoke_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.invoke_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Create SNS Topic
resource "aws_sns_topic" "key_rotation_topic" {
  name = "key-rotation-topic"
}

# Create Lambda Function
resource "aws_lambda_function" "iam_scripts" {
  filename         = "function.zip"
  function_name    = "Iam_scripts"
  role             = aws_iam_role.invoke_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("function.zip")
  runtime          = "python3.8"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.key_rotation_topic.arn
    }
  }
}

# Set Lambda Function Timeout and Memory Size
resource "aws_lambda_function_configuration" "iam_scripts_config" {
  function_name = aws_lambda_function.iam_scripts.function_name
  timeout       = 600 # 10 minutes
  memory_size   = 128
}

# Create CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "iam_scripts_schedule" {
  name        = "IamScriptsSchedule"
  description = "Triggers the Iam_scripts Lambda function on a schedule"
  schedule_expression = "rate(7 days)"
}

# Create CloudWatch Event Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.iam_scripts_schedule.name
  target_id = "IamScriptsLambdaTarget"
  arn       = aws_lambda_function.iam_scripts.arn
}

# Grant CloudWatch Permission to Invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_scripts.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.iam_scripts_schedule.arn
}

# Zip the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "path/to/your/lambda_function_directory"
  output_path = "path/to/your/function.zip"
}

output "sns_topic_arn" {
  value = aws_sns_topic.key_rotation_topic.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.iam_scripts.function_name
}
