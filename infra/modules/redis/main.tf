# Provider 
provider "helm" {
  kubernetes {
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

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "auth.enabled"
    value = var.auth_enabled
  }

  set {
    name  = "master.persistence.enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "replica.replicaCount"
    value = var.replica_count
  }
}