# ArgoCD 모듈 main.tf

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "argocd_sa" {
  metadata {
    name      = "argocd-service-account"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.irsa_role_arn
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = var.namespace

  set {
    name  = "server.serviceAccount.name"
    value = kubernetes_service_account.argocd_sa.metadata[0].name
  }

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  depends_on = [kubernetes_service_account.argocd_sa]
}
