# VPC Creation
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-1"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "internet-gw"
  }
}

# Public Subnet
resource "aws_subnet" "pb_sn" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.pb_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "pb_1"
  }
}

# Private Subnet
resource "aws_subnet" "pv_sn" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pv_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "pv_1"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway for Private Subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pb_sn.id

  tags = {
    Name = "nat-gateway"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "pb_association" {
  subnet_id      = aws_subnet.pb_sn.id
  route_table_id = aws_route_table.public_rt.id
}

# Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Route Table Association for Private Subnet
resource "aws_route_table_association" "pv_association" {
  subnet_id      = aws_subnet.pv_sn.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group
resource "aws_security_group" "pb_sg" {
  name        = "my sg"
  description = "SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ext_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ext_ip]
  }
}
