# FluentBit IRSA 모듈 variables.tf

variable "role_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  description = "Service account name for Fluent Bit IRSA"
  type        = string
}

variable "oidc_provider_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "policy_arns" {
  type    = list(string)
  default = []
}
