output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "subnet-ids" {
  value = [aws_subnet.SN-1.id, aws_subnet.SN-2.id, aws_subnet.SN-3.id]
}