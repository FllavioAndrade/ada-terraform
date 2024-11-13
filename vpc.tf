resource "aws_vpc" "ada_vpc" {
  cidr_block = var.cirdvpc
  #  instance_tenancy = "default" Opcional

  tags = {
    vpc  = "ada"
    Name = "terraformada"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-a"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-b"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "public-c" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "public-c"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_internet_gateway" "gw-ada" {
  vpc_id = aws_vpc.ada_vpc.id

  tags = {
    Name = "gw-ada"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-a"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-b"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "private-c" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-c"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "dados-a" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dados-a"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "dados-b" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dados-b"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "dados-c" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.9.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "dados-c"
  }
  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_eip" "nat_eip-a" {
}

resource "aws_nat_gateway" "nat_gateway-a" {
  allocation_id = aws_eip.nat_eip-a.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name = "NAT-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw-ada]
}

resource "aws_eip" "nat_eip-b" {
}

resource "aws_nat_gateway" "nat_gateway-b" {
  allocation_id = aws_eip.nat_eip-b.id
  subnet_id     = aws_subnet.public-b.id

  tags = {
    Name = "NAT-b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw-ada]
}

resource "aws_eip" "nat_eip-c" {
}

resource "aws_nat_gateway" "nat_gateway-c" {
  allocation_id = aws_eip.nat_eip-c.id
  subnet_id     = aws_subnet.public-c.id

  tags = {
    Name = "NAT-c"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw-ada]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-ada.id
  }

}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "banco" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}
resource "aws_route_table_association" "dados-a" {
  subnet_id      = aws_subnet.dados-a.id
  route_table_id = aws_route_table.banco.id

}

resource "aws_route_table_association" "dados-b" {
  subnet_id      = aws_subnet.dados-b.id
  route_table_id = aws_route_table.banco.id

}

resource "aws_route_table_association" "dados-c" {
  subnet_id      = aws_subnet.dados-c.id
  route_table_id = aws_route_table.banco.id

}

resource "aws_route_table" "privadaappa" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway-a.id
  }
}
resource "aws_route_table" "privadaappb" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway-b.id
  }
}
resource "aws_route_table" "privadaappc" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway-c.id
  }
}

resource "aws_route_table_association" "app-a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.privadaappa.id
}
resource "aws_route_table_association" "app-b" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.privadaappa.id
}
resource "aws_route_table_association" "app-c" {
  subnet_id      = aws_subnet.private-c.id
  route_table_id = aws_route_table.privadaappa.id
}