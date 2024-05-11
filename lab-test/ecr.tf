# ECR repository
resource "aws_ecr_repository" "fe" {
  name = "${var.service}-repo-fe"
}
resource "aws_ecr_repository" "be" {
  name = "${var.service}-repo-be"
}

# ECR lifecycle Policy
resource "aws_ecr_lifecycle_policy" "fe-policy" {
  repository = aws_ecr_repository.fe.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 10,
            "description": "Keep last 50 images untagged",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 20,
            "description": "Keep last 100 images tagged",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${var.service}"],
                "countType": "imageCountMoreThan",
                "countNumber": 100
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 30,
            "description": "Keep last 50 images any",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "be-policy" {
  repository = aws_ecr_repository.be.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 10,
            "description": "Keep last 50 images untagged",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 20,
            "description": "Keep last 100 images tagged",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${var.service}"],
                "countType": "imageCountMoreThan",
                "countNumber": 100
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 30,
            "description": "Keep last 50 images any",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}