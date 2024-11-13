data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "EC2-a" {

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public-a.id
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1a"

  tags = {
    Name = "EC2-a"
  }
}

resource "aws_instance" "EC2-b" {
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public-b.id
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1b"

  tags = {
    Name = "EC2-b"
  }
}

resource "aws_instance" "EC2-c" {
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public-c.id
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1c"

  tags = {
    Name = "EC2-c"
  }
}