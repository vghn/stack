output "bucket" {
  description = "The name of the backup bucket"
  value       = "${aws_s3_bucket.vgbak.id}"
}
