resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.2.10"

  create_namespace = false

  set = [
    {
      name  = "adminPassword"
      value = "admin1234"
    }
  ]
} 