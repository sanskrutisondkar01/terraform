resource "aws_s3_bucket" "s3" {
    bucket = "aws-s3-sans-bucket "
    tags ={
        Name = "aws-s3-sans-bucket "
    }
  
}