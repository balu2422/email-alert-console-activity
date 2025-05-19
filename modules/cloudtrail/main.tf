resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "cloudtrail-activity-logs-${random_id.suffix.hex}"
  force_destroy = true
  tags = {
    Name = "CloudTrailLogsBucket"
  }
}

resource "aws_cloudwatch_log_group" "trail" {
  name              = "/aws/cloudtrail/activity"
  retention_in_days = 7
}

resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "cloudtrail-cloudwatch-policy"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Resource = "${aws_cloudwatch_log_group.trail.arn}:*"
      }
    ]
  })
}

resource "aws_cloudtrail" "trail" {
  name                          = "account-activity-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.trail.arn
}

resource "aws_cloudtrail_logging" "trail_logging" {
  name = aws_cloudtrail.trail.name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.trail.name
}
