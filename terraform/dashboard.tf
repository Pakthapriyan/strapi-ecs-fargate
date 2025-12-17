resource "aws_cloudwatch_dashboard" "strapi" {
  dashboard_name = "paktha-strapi-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # ECS CPU Utilization
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
      # ECS Memory Utilization
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

      # Task Count (Running vs Desired)
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Task Count (Running vs Desired)"
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
      },
      # Network In (Bytes)
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Network In (Bytes)"
          region = var.aws_region
          stat   = "Sum"
          period = 60

          metrics = [
            [
              "AWS/ECS",
              "NetworkRxBytes",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
        }
      },
      # Network Out (Bytes)
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "Network Out (Bytes)"
          region = var.aws_region
          stat   = "Sum"
          period = 60

          metrics = [
            [
              "AWS/ECS",
              "NetworkTxBytes",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
        }
      }
    ]
  })
}
