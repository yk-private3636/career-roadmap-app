module "ext_dns_role" {
  source = "../../modules/iam_role"

  role_name               = local.ext_dns_role_name
  assume_role_policy_json = data.aws_iam_policy_document.ext_dns_assume_role.json
  policies = {
    (local.ext_dns_role_policy_name) = data.aws_iam_policy_document.ext_dns_role_policy.json
  }
}

data "aws_iam_policy_document" "ext_dns_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.eks.arn,
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_cluster_oidc_provider_name}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${local.eks_cluster_oidc_provider_name}:sub"
      values   = ["system:serviceaccount:${local.eks_namespace_name}:${local.eks_ingress_ext_dns_sa_name}"]
    }
  }
}

data "aws_iam_policy_document" "ext_dns_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.api.zone_id}"
    ]

    condition {
      test     = "ForAllValues:StringLike"
      variable = "route53:ChangeResourceRecordSetsNormalizedRecordNames"
      values   = [var.domain_names.api, "*.${var.domain_names.api}"]
    }
    condition {
      test     = "ForAllValues:StringLike"
      variable = "route53:ChangeResourceRecordSetsActions"
      values   = ["CREATE", "UPSERT", "DELETE"]
    }
    condition {
      test     = "ForAllValues:StringLike"
      variable = "route53:ChangeResourceRecordSetsRecordTypes"
      values   = ["A", "AAAA", "CNAME", "MX", "TXT"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["route53:ListHostedZones"]
    resources = ["*"]
  }
}
