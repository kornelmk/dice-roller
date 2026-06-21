# Bucket na logi aplikacji
resource "aws_s3_bucket" "app_logs" {
  bucket = "dice-roller-app-logs"

  tags = merge(local.tags, {
    Name = "dice-roller-app-logs"
  })
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