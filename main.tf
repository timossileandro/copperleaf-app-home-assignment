# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = local.tags
}


# Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_a
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags                    = local.tags
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_b
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true
  tags                    = local.tags
}


# Private Subnets
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private_a
  availability_zone = "ap-southeast-2a"
  tags              = local.tags
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private_b
  availability_zone = "ap-southeast-2b"
  tags              = local.tags
}


# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags
}


# NAT Gateways
resource "aws_nat_gateway" "ngwa" {
  allocation_id = aws_eip.nateipa.id
  subnet_id     = aws_subnet.public_a.id
  tags          = local.tags
}

resource "aws_eip" "nateipa" {
  domain = "vpc"
  tags   = local.tags
}

resource "aws_nat_gateway" "ngwb" {
  allocation_id = aws_eip.nateipb.id
  subnet_id     = aws_subnet.public_b.id
  tags          = local.tags
}

resource "aws_eip" "nateipb" {
  domain = "vpc"
  tags   = local.tags
}


# Public Routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


# Private Routes
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private1" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngwa.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private2" {
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngwb.id
}

resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private2.id
}