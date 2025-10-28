resource "aws_s3_bucket" "artefact_bucket" {
  bucket        = "${var.app_name}-artefacts-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "artefact_bucket" {
  bucket = aws_s3_bucket.artefact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
