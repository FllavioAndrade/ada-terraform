resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.ada_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ada_vpc.cidr_block]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ada_vpc.cidr_block]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ada_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  vpc_id = aws_vpc.ada_vpc.id
  subnet_ids = [
    aws_subnet.dados-a.id,
    aws_subnet.dados-b.id,
    aws_subnet.dados-c.id
  ]
}

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.ada_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}