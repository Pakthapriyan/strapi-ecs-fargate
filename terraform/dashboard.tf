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
          title  = "Task CPU Utilization"
          region = var.aws_region
          period = 60
          stat   = "Average"

          metrics = [
            [
              "ECS/ContainerInsights",
              "TaskCpuUtilization",
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
          title  = "Task Memory Utilization"
          region = var.aws_region
          period = 60
          stat   = "Average"

          metrics = [
            [
              "ECS/ContainerInsights",
              "TaskMemoryUtilization",
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
          period = 60
          stat   = "Average"

          metrics = [
            [
              "ECS/ContainerInsights",
              "RunningTaskCount",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ],
            [
              ".",
              "DesiredTaskCount",
              ".",
              ".",
              ".",
              "."
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Network In / Out"
          region = var.aws_region
          period = 60
          stat   = "Sum"

          metrics = [
            [
              "ECS/ContainerInsights",
              "NetworkRxBytes",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ],
            [
              ".",
              "NetworkTxBytes",
              ".",
              ".",
              ".",
              "."
            ]
          ]
        }
      }

    ]
  })
}
