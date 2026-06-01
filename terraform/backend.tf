terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-aruna451"   # ← your S3 bucket name
    key            = "ecs-app/terraform.tfstate"
    region         = "us-east-1"                   # ← your region
    dynamodb_table = "terraform-state-lock"        # ← for state locking
    encrypt        = true
  }
}