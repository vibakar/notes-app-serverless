resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/app/${var.app_name}"
  retention_in_days = 7

  tags = {
    Application = "${var.app_name}"
  }
}