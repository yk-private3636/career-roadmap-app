module "ecr" {
  source = "../../modules/ecr"

  repository_name = local.ecr_repository_name
  force_delete    = true
  lifecycle_policy_json = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the 2 most recent api-* tagged images"
      selection = {
        tagStatus      = "tagged"
        tagPatternList = ["api-*"]
        storageClass   = "standard"
        countType      = "imageCountMoreThan"
        countNumber    = 2
      }
      action = {
        type = "expire"
      }
      }, {
      rulePriority = 2
      description  = "Keep only the 2 most recent batch-* tagged images"
      selection = {
        tagStatus      = "tagged"
        tagPatternList = ["batch-*"]
        storageClass   = "standard"
        countType      = "imageCountMoreThan"
        countNumber    = 2
      }
      action = {
        type = "expire"
      }
      }, {
      rulePriority = 3
      description  = "Keep only the 2 most recent job-* tagged images"
      selection = {
        tagStatus      = "tagged"
        tagPatternList = ["job-*"]
        storageClass   = "standard"
        countType      = "imageCountMoreThan"
        countNumber    = 2
      }
      action = {
        type = "expire"
      }
    }]
  })
}