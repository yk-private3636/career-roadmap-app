locals {
  name = "${var.env}-${var.project_name}"

  terraform_role_name        = "${local.name}-terraform-role"
  terraform_role_policy_name = "${local.name}-terraform-role-policy"

  lb_ctl_role_name        = "${local.name}-lb-ctl-role"
  lb_ctl_role_policy_name = "${local.name}-lb-ctl-role-policy"

  subnet_public_name  = "${local.name}-public-subnet"
  subnet_private_name = "${local.name}-private-subnet"

  ecr_repository_name = "${local.name}-repository"

  eks_cluster_name               = "${local.name}-eks-cluster"
  eks_cluster_role_name          = "${local.name}-eks-cluster-role"
  eks_node_group_name            = "${local.name}-eks-node-group"
  eks_node_group_role_name       = "${local.name}-eks-node-group-role"
  eks_cluster_sg_name            = "${local.name}-eks-cluster-sg"
  eks_cluster_oidc_provider_name = replace(module.eks.oidc_issuer, "https://", "")
  eks_namespace_name             = local.name
  eks_service_account_name       = "${var.env}-ingress-controller-serviceaccount"
}