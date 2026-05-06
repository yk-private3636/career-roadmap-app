resource "aws_eks_cluster" "main" {
    name = var.cluster_name
    role_arn = aws_iam_role.cluster.arn
    version = "1.31"
    deletion_protection = true
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

resource "aws_eks_access_entry" "main" {
  for_each = tomap({ for idx, arn in [var.admin_principal_arn, aws_iam_role.node_group.arn] : idx => arn })
  cluster_name = aws_eks_cluster.main.name
  principal_arn = each.value
  type = "STANDARD"
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

resource "aws_iam_role_policy" "node_group" {
  for_each = var.node_group_policies

  name   = each.key
  role   = aws_iam_role.node_group.id
  policy = each.value
}
