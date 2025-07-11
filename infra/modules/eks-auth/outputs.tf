output "aws_auth_configmap_name" {
  description = "aws-auth ConfigMap 이름"
  value       = kubernetes_config_map.aws_auth.metadata[0].name
} 