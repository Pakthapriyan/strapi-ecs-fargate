resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "ecs-strapi-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi.name
    ServiceName = aws_ecs_service.strapi.name
  }

  alarm_description = "High CPU usage on Strapi ECS service"
}
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "ecs-strapi-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi.name
    ServiceName = aws_ecs_service.strapi.name
  }

  alarm_description = "High CPU usage on Strapi ECS service"
}
