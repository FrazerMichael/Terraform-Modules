resource "aws_vpc" "vpc" {
  name = "${var.cluster}-vpc"

  cidr_block                       = var.cidr-block
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  tags                             = { Name = "${var.cluster}-vpc" }
}
resource "aws_internet_gateway" "igw" {
  name = "${var.cluster}-igw"

  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-igw" }
}

resource "aws_route_table" "public-RT" {
  name = "${var.cluster}-public-RT"

  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-public-RT"}
}

resource "aws_route_table" "private-RT" {
  name = "${var.cluster}-private-RT"

  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-private-RT" }
}

resource "aws_route" "igw-route" {
  route_table_id         = aws_route_table.public-RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public-SN" {
  name = "${var.cluster}-public-SN"

  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.azs[0]
  cidr_block        = var.public-cidr
  tags              = { Name = "${var.cluster}-public-SN"}
}

resource "aws_subnet" "private-SN" {
  name = "${var.cluster}-private-SN"

  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.azs[1]
  cidr_block        = var.private-cidr
  tags              = { Name = "${var.cluster}-private-SN" }
}
