resource "aws_cloudwatch_dashboard" "strapi" {
  dashboard_name = "paktha-strapi-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # -------------------------
      # CPU Utilization
      # -------------------------
      {
        type = "metric"
        x    = 0
        y    = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS CPU Utilization"
          region = var.aws_region
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
          period = 300
          stat   = "Average"
        }
      },

      # -------------------------
      # Memory Utilization
      # -------------------------
      {
        type = "metric"
        x    = 12
        y    = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS Memory Utilization"
          region = var.aws_region
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
          period = 300
          stat   = "Average"
        }
      },

      # Running Task Count
      {
        type = "metric"
        x    = 0
        y    = 6
        width  = 12
        height = 6

        properties = {
          title  = "Running Task Count"
          region = var.aws_region
          metrics = [
            [
              "AWS/ECS",
              "RunningTaskCount",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
          period = 300
          stat   = "Average"
        }
      },

     
      # Network In / Out
      {
        type = "metric"
        x    = 12
        y    = 6
        width  = 12
        height = 6

        properties = {
          title  = "Network In / Out"
          region = var.aws_region
          metrics = [
            [
              "AWS/ECS",
              "NetworkRxBytes",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ],
            [
              "AWS/ECS",
              "NetworkTxBytes",
              "ClusterName", aws_ecs_cluster.strapi.name,
              "ServiceName", aws_ecs_service.strapi.name
            ]
          ]
          period = 300
          stat   = "Sum"
        }
      }
    ]
  })
}
