resource "aws_s3_bucket" "s3" {
  bucket = "${var.project}-artifact-storage"
}

resource "aws_s3_bucket_acl" "s3-acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3-ver" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}


/*resource "aws_s3_bucket" "s3" {
  bucket = "${var.project}-artifact-storage"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }
  }

  tags = {
    Name = "${var.project}-artifact-storage"
  }
}*/