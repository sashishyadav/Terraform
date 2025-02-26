region               = "us-east-1"
lambda_function_name = "Iam_scripts"
sns_topic_name       = "key-rotation-topic"
lambda_timeout       = 300
lambda_memory_size   = 128
schedule_expression  = "rate(7 days)"
