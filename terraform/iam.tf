resource "aws_iam_role" "ecs_task_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ─────────────────────────────────────────
# Fix: Grant devopps user ECS + IAM permissions
# ─────────────────────────────────────────
resource "aws_iam_policy" "devopps_deploy_policy" {
  name        = "devopps-deploy-policy"
  description = "Grants devopps user permissions to deploy ECS infrastructure"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ECSFullAccess"
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeClusters",
          "ecs:ListClusters",
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTaskDefinitions",
          "ecs:CreateService",
          "ecs:UpdateService",
          "ecs:DeleteService",
          "ecs:DescribeServices",
          "ecs:ListServices",
          "ecs:RunTask",
          "ecs:StopTask",
          "ecs:DescribeTasks",
          "ecs:ListTasks"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMAccess"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRoles",
          "iam:TagRole",
          "iam:UntagRole"
        ]
        Resource = "*"
      },
      {
        Sid    = "ECRAccess"
        Effect = "Allow"
        Action = ["ecr:*"]
        Resource = "*"
      },
      {
        Sid    = "ELBAccess"
        Effect = "Allow"
        Action = ["elasticloadbalancing:*"]
        Resource = "*"
      },
      {
        Sid    = "EC2Access"
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeRouteTables",
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to devopps user
resource "aws_iam_user_policy_attachment" "devopps_attach" {
  user       = "devopps"
  policy_arn = aws_iam_policy.devopps_deploy_policy.arn
}