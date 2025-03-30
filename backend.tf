terraform {
  backend "s3" {
    bucket         = "terraform-vpc-ec2"
    key            = "state"  # Recommended to use a clear folder structure
    region         = "us-east-1"
    dynamodb_table = "terraform-table"
  }
}