

resource "aws_cloudwatch_log_metric_filter" "login_filter" {
  name           = "console-login-filter"
  log_group_name = var.log_group_name
  pattern        = "{ $.eventName = \"ConsoleLogin\" }"

  metric_transformation {
    name      = "ConsoleLoginEventCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}
