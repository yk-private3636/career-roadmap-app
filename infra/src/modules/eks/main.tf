resource "aws_eks_cluster" "main" {
    name = var.cluster_name
    role_arn = aws_iam_role.cluster.arn
    version = "1.31"
    deletion_protection = true
    bootstrap_self_managed_addons = true
    vpc_config {
        endpoint_public_access = true
        endpoint_private_access = true
        subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
        security_group_ids = var.cluster_security_group_ids
    }
    access_config {
      authentication_mode = "API"
      bootstrap_cluster_creator_admin_permissions = false
    }
    compute_config {
      enabled = false
    }
    kubernetes_network_config {
        elastic_load_balancing {
          enabled = false
        }
    }
    storage_config {
        block_storage {
          enabled = false
        }
    }

    depends_on = [ aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy ]
}

resource "aws_eks_node_group" "main" {
    cluster_name = aws_eks_cluster.main.name
    node_group_name = var.node_group_name
    node_role_arn = aws_iam_role.node_group.arn
    ami_type =  "AL2_x86_64" 
    instance_types = var.node_group_instance_types
    disk_size = var.node_group_disk_size
    subnet_ids = var.private_subnet_ids
    scaling_config {
      min_size = var.scaling.min
      max_size = var.scaling.max
      desired_size = var.scaling.desired
    }
    lifecycle {
      ignore_changes = [ scaling_config[0].desired_size ]
    }
}

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_entry" "node_group" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_role.node_group.arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

resource "aws_iam_role" "cluster" {
  name = var.cluster_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "node_group" {
  name = var.node_group_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

# data "aws_iam_policy_document" "ecr_access_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ecr:GetAuthorizationToken",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:GetRepositoryPolicy",
#       "ecr:DescribeRepositories",
#       "ecr:ListImages",
#       "ecr:DescribeImages",
#       "ecr:BatchGetImage",
#       "ecr:GetLifecyclePolicy",
#       "ecr:GetLifecyclePolicyPreview",
#       "ecr:ListTagsForResource",
#       "ecr:DescribeImageScanFindings"
#     ]
#     resources = [
#       var.ecr_arn,
#       "${var.ecr_arn}/*"
#     ]
#   }
# }

# data "aws_iam_policy_document" "eks_access_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:DescribeInstances",
#       "ec2:DescribeInstanceTypes",
#       "ec2:DescribeRouteTables",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeVolumes",
#       "ec2:DescribeVolumesModifications",
#       "ec2:DescribeVpcs",
#       "eks:DescribeCluster",
#       "eks-auth:AssumeRoleForPodIdentity"
#     ]
#     resources = [
#       aws_eks_cluster.main.arn
#     ]
#   } 
# }

# data "aws_iam_policy_document" "eks_cni_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:AssignPrivateIpAddresses",
#       "ec2:AttachNetworkInterface",
#       "ec2:CreateNetworkInterface",
#       "ec2:DeleteNetworkInterface",
#       "ec2:DescribeInstances",
#       "ec2:DescribeTags",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeInstanceTypes",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DetachNetworkInterface",
#       "ec2:ModifyNetworkInterfaceAttribute",
#       "ec2:UnassignPrivateIpAddresses"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:CreateTags"
#     ]
#     resources = [
#       "arn:aws:ec2:*:*:network-interface/*"
#     ]
#   }
# }

# resource "aws_iam_role_policy" "ecr_access_policy" {
#   policy = data.aws_iam_policy_document.ecr_access_policy.json
#   role       = aws_iam_role.node_group.name
# }

# resource "aws_iam_role_policy" "eks_access_policy" {
#   policy = data.aws_iam_policy_document.eks_access_policy.json
#   role       = aws_iam_role.node_group.name
# }

# resource "aws_iam_role_policy" "eks_cni_policy" {
#   policy = data.aws_iam_policy_document.eks_cni_policy.json
#   role       = aws_iam_role.node_group.name
# }

resource "aws_iam_role_policy" "add_node_group_policy" {
  for_each = var.node_group_policies

  policy = each.value
  role = aws_iam_role.node_group.name
}
