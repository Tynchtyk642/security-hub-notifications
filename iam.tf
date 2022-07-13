resource "aws_iam_role" "sns_role" {
  count = local.create_sns_notification
  name = "${var.env}-SendEmailLambdaExecutionRole"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  inline_policy {
    name   = "sns_policy"
    policy = data.aws_iam_policy_document.sns_policy[count.index].json
  }
}

resource "aws_iam_role_policy_attachment" "securityhub_policy" {
  count = local.create_sns_notification
  role       = aws_iam_role.sns_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubReadOnlyAccess"
}

data "aws_iam_policy_document" "sns_policy" {
  count = local.create_sns_notification



























































































































  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.sns-topic-securityhub[count.index].arn}"]
  }

}

