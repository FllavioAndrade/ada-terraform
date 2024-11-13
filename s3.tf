resource "aws_s3_bucket" "ada_bucket" {
  bucket = "fllavioandrade-ada"

  tags = {
    Name        = "ada_bucket"
    Environment = "DevOps"
  }
  force_destroy = true

  # Habilita o bucket para armazenar o estado do Terraform
  versioning {
    enabled = true
  }

  # Habilita o bloqueio de vers o para o bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


