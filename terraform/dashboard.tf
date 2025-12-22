resource "aws_cloudwatch_dashboard" "strapi" {
  dashboard_name = "paktha-strapi-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ECS CPU Utilization"
          region = var.aws_region
          stat   = "Average"
          period = 60
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ECS Memory Utilization"
          region = var.aws_region
          stat   = "Average"
          period = 60
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "Running vs Desired Tasks"
          region = var.aws_region
          stat   = "Average"
          period = 60
          metrics = [
            [
              "AWS/ECS",
              "RunningTaskCount",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ],
            [
              "AWS/ECS",
              "DesiredTaskCount",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
        }
      }
    ]
  })
}
