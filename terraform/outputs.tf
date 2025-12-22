output "cluster_name" {
  value = aws_ecs_cluster.strapi.name
}

output "log_group" {
  value = data.aws_cloudwatch_log_group.strapi.name
}
