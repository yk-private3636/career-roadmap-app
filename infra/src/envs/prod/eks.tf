module "eks" {
  source                     = "../../modules/eks"
  cluster_name               = local.eks_cluster_name
  cluster_iam_role_name      = local.eks_cluster_role_name
  public_subnet_ids          = []
  private_subnet_ids         = [for subnet in aws_subnet.private : subnet.id]
  cluster_security_group_ids = [aws_security_group.eks_cluster.id]
  admin_principal_arn        = module.terraform_role.role_arn
  node_group_name            = local.eks_node_group_name
  node_group_iam_role_name   = local.eks_node_group_role_name
  node_group_instance_types  = ["t3.medium"]
  node_group_disk_size       = 32
  scaling = {
    min     = 3
    max     = 5
    desired = 3
  }
  node_group_policies = {
    (local.eks_node_group_policy_name) = data.aws_iam_policy_document.esk_ecr_access_policy.json
  }
}

resource "aws_security_group" "eks_cluster" {
  name   = local.eks_cluster_sg_name
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv4         = aws_vpc.main.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "eks_cluster" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv4         = aws_vpc.main.cidr_block
}

data "aws_iam_policy_document" "esk_ecr_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      module.ecr.arn,
      "${module.ecr.arn}/*"
    ]
  }
}