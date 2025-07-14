# ArgoCD 모듈 main.tf

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = var.namespace

  set = [
    # IRSA 연동: ServiceAccount에 eks.amazonaws.com/role-arn annotation을 추가하여
    # EKS의 OIDC와 연결된 IAM Role을 ArgoCD에 부여합니다.
    # var.irsa_role_arn은 IRSA 모듈에서 생성된 IAM Role ARN입니다.
    {
      name  = "server.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.irsa_role_arn
    },
    # ArgoCD 서버를 LoadBalancer 타입으로 노출
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    }
  ]
}
