# Helm으로 생성하는 코드
# Provider 
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

# Resource 
resource "helm_release" "redis" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = var.chart_version

  set = [
    {
      name  = "auth.enabled"
      value = var.auth_enabled
    },
    {
      name  = "master.persistence.enabled"
      value = var.persistence_enabled
    },
    {
      name  = "replica.replicaCount"
      value = var.replica_count
    }
  ]
}