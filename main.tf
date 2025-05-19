module "cloudtrail" {
  source = "./modules/cloudtrail"
}

module "cloudwatch_logs" {
  source            = "./modules/cloudwatch_logs"
  log_group_name    = module.cloudtrail.log_group_name
}

module "sns" {
  source      = "./modules/sns"
  email       = var.notification_email
}

module "alarm" {
  source            = "./modules/alarm"
  log_group_name    = module.cloudtrail.log_group_name
  filter_pattern    = "{ $.eventName = \"ConsoleLogin\" }"
  sns_topic_arn     = module.sns.topic_arn
}
