resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.cluster}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-igw" }
}

resource "aws_subnet" "public-SN" {
  vpc_id                                      = aws_vpc.vpc.id
  availability_zone                           = var.azs[0]
  cidr_block                                  = var.cidr-blocks[0]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true
  tags                                        = { Name = "SN-${var.cluster}-1" }
}

resource "aws_subnet" "public-SN" {
  vpc_id                                      = aws_vpc.vpc.id
  availability_zone                           = var.azs[1]
  cidr_block                                  = var.cidr-blocks[1]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true
  tags                                        = { Name = "SN-${var.cluster}-2" }
}

resource "aws_subnet" "public-SN" {
  vpc_id                                      = aws_vpc.vpc.id
  availability_zone                           = var.azs[2]
  cidr_block                                  = var.cidr-blocks[2]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true
  tags                                        = { Name = "SN-${var.cluster}-3" }
}


resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.cluster}-public-RT" }
}

resource "aws_route_table_association" "public-RT-SN-1" {
  subnet_id      = aws_subnet.SN-1.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "public-RT-SN-2" {
  subnet_id      = aws_subnet.SN-2.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "public-RT-SN-3" {
  subnet_id      = aws_subnet.SN-3.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route" "igw-route" {
  route_table_id         = aws_route_table.public-RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}