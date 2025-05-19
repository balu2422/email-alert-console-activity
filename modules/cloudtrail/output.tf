output "log_group_name" {
  value = aws_cloudwatch_log_group.trail.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.trail_bucket.bucket
}
