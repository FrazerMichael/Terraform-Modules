output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "public-SN-id" {
  value = aws_subnet.public-SN.id
}

output "private-SN-id" {
  value = aws_subnet.private-SN.id
}