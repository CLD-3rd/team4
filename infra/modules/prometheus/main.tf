resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "75.10.0"

  create_namespace = true

  set = [
    {
      name  = "grafana.enabled"
      value = "false"
    }
  ]
} 