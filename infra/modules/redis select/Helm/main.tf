# Helm으로 생성하는 코드
# Resource 
resource "helm_release" "redis" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = var.chart_version
  wait       = false  # 수정: Pod 완료를 기다리지 않음

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