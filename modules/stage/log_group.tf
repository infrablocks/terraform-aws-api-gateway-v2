resource "aws_cloudwatch_log_group" "access_logs" {
  name = "/${var.component}/${var.deployment_identifier}/api-gateway/${local.sanitised_name}"
}

data "aws_iam_policy_document" "api_gateway_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = [
        "apigateway.amazonaws.com"
      ]
      type = "Service"
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "api_gateway_logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "api_gateway_logging_role" {
  name = "api-gateway-logging-role-${var.component}-${var.deployment_identifier}-${local.sanitised_name}"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role_policy.json
}

resource "aws_iam_role_policy" "api_gateway_logging_role_policy" {
  name = "api-gateway-logging-policy-${var.component}-${var.deployment_identifier}-${local.sanitised_name}"
  role = aws_iam_role.api_gateway_logging_role.name
  policy = data.aws_iam_policy_document.api_gateway_logging_policy.json
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_logging_role.arn
}
