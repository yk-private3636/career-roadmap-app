resource "aws_ecr_repository" "main" {
    name = var.repository_name
    image_tag_mutability = "IMMUTABLE"
    force_delete = var.force_delete

    image_scanning_configuration {
        scan_on_push = true
    }

    encryption_configuration {
        encryption_type = "AES256"
    }
}

resource "aws_ecr_lifecycle_policy" "main" {
    repository = aws_ecr_repository.main.name
    policy = var.lifecycle_policy_json
}