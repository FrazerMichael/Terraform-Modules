locals {
  open-cidr = "0.0.0.0/0"
}


resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr-block
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  tags                             = { Name = "${var.cluster}-vpc" }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-igw" }
}

resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-public-RT" }
}

resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-private-RT" }
}

resource "aws_route" "igw-route" {
  route_table_id         = aws_route_table.public-RT.id
  destination_cidr_block = local.open-cidr
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_subnet" "public-SN" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.azs[0]
  cidr_block        = var.public-cidr
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true
  tags              = { Name = "${var.cluster}-public-SN" }
}

resource "aws_subnet" "private-SN" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.azs[1]
  cidr_block        = var.private-cidr
  tags              = { Name = "${var.cluster}-private-SN" }
}

resource "aws_eip" "eip-public-SN" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip-public-SN.id
  subnet_id     = aws_subnet.public-SN.id
  tags = {Name = "${var.cluster}-NAT-gw"}
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route" "nat-route" {
  depends_on = [aws_nat_gateway.nat-gw]
  route_table_id = aws_route_table.private-RT.id
  destination_cidr_block = local.open-cidr
  gateway_id = aws_nat_gateway.nat-gw.id
}

resource "aws_route_table_association" "private-RT-SN-assoc" {
  subnet_id      = aws_subnet.private-SN.id
  route_table_id = aws_route_table.private-RT.id
}

resource "aws_route_table_association" "public-RT-SN-assoc" {
  subnet_id      = aws_subnet.public-SN.id
  route_table_id = aws_route_table.public-RT.id
}