locals {

  create_sns_notification = var.env == "prod" ? 1 : 0
  sns_endpoint = [
    "tynchtyk642@gmail.com"
  ]
}

resource "aws_lambda_function" "send_sns" {
  count = local.create_sns_notification
  function_name = "${var.env}-SecurityHubEmail"

  runtime          = "python3.7"
  handler          = "index.lambda_handler"
  role             = aws_iam_role.sns_role[count.index].arn
  timeout          = 30
  filename         = "${path.module}/functions/index.zip"
  source_code_hash = data.archive_file.send_sns.output_base64sha256

  environment {
    variables = {
      "ARNInsight01"              = aws_securityhub_insight.compliance_status[count.index].arn
      "ARNInsight02"              = aws_securityhub_insight.sns_custom_insight2[count.index].arn
      "ARNInsight03"              = aws_securityhub_insight.sns_custom_insight3[count.index].arn
      "ARNInsight04"              = aws_securityhub_insight.sns_custom_insight4[count.index].arn
      "ARNInsight05"              = aws_securityhub_insight.sns_custom_insight5[count.index].arn
      "ARNInsight06"              = aws_securityhub_insight.sns_custom_insight6[count.index].arn
      "ARNInsight07"              = aws_securityhub_insight.sns_custom_insight7[count.index].arn
      "AdditionalEmailFooterText" = "This is footer  text"
      "SNSTopic"                  = aws_sns_topic.securityhub_recurring_summary[count.index].arn
    }
  }
}

data "archive_file" "send_sns" {
  type        = "zip"
  source_file = "${path.module}/functions/index.py"
  output_path = "${path.module}/functions/index.zip"
}

resource "aws_lambda_permission" "sns_function" {
  count = local.create_sns_notification
  statement_id  = "AllowExecutionFromCLoudWatch"
  action        = "lambda:InvokeFuncion"
  function_name = aws_lambda_function.send_sns[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sns_shedule[count.index].arn
}

resource "aws_cloudwatch_event_rule" "sns_shedule" {
  count = local.create_sns_notification
  name                = "${var.env}-sns_shedule"
  description         = "Triggers the Recurring Security Hub summary email"
  event_pattern       = ""
  schedule_expression = "cron(57 23 ? * 2 *)"
}

resource "aws_cloudwatch_event_target" "sns_trigger" {
  count = local.create_sns_notification
  arn  = aws_lambda_function.send_sns[count.index].arn
  rule = aws_cloudwatch_event_rule.sns_shedule[count.index].name
}

resource "aws_sns_topic" "securityhub_recurring_summary" {
  count = local.create_sns_notification
  display_name = "Security Hub Summary Report"
  name         = "${var.env}-SecurityHubRecurringSummary"
}

resource "aws_sns_topic_subscription" "sns_endpoint" {
  count     = local.create_sns_notification == "prod" ? length(local.sns_endpoint) : 0
  topic_arn = aws_sns_topic.securityhub_recurring_summary[count.index].arn
  protocol  = "email"
  endpoint  = local.sns_endpoint[count.index]
}




