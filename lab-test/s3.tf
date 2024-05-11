resource "aws_s3_bucket" "lab" {
  bucket = "${var.aws_region}-${var.service}-${var.s3["lab_bucket_name"]}"
  acl    = "private"

  versioning {
    enabled = true
  }
}