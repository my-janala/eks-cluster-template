variable "environment" {
  description = "Environment name (e.g., rte-b, rte-a, dco-sit-a, dco-sit-b, dco-uit-a, dco-uit-b, dco-prod-a, dco-prod-b)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace for ArgoCD deployment"
  type        = string
  default     = "argocd"
}