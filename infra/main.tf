terraform {
  backend "s3" {
    bucket         = "terraform-state-dice-roller"
    key            = "dice-roller/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock-dice-roller"
  }
          
 required_providers {
	    aws = {
    	source  = "hashicorp/aws"
  	version = "5.91.0"
	     }
  }
  required_version = "1.11.3"
}

# Bucket na logi aplikacji
resource "aws_s3_bucket" "app_logs" {
  bucket = "dice-roller-app-logs"
}

# Wersjonowanie logów
resource "aws_s3_bucket_versioning" "app_logs_versioning" {
  bucket = aws_s3_bucket.app_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Szyfrowanie logów
resource "aws_s3_bucket_server_side_encryption_configuration" "app_logs_encryption" {
  bucket = aws_s3_bucket.app_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}