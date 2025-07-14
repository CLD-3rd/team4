# FluentBit 모듈 main.tf

resource "helm_release" "fluentbit" {
  name       = "aws-for-fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  namespace  = var.namespace
  create_namespace = true

  values = [yamlencode({
    serviceAccount = {
      create = false
      name   = var.service_account_name
    }
    cloudWatch = {
      logGroupName    = var.log_group_name
      logStreamPrefix = "fluent-bit-"
    }
    backend = {
      type = "cloudwatch"
    }
  })]
}
