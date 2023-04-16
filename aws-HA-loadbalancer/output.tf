output "subnet-ids" {
  value = [aws_subnet.SN-1.id, aws_subnet.SN-2.id, aws_subnet.SN-3.id]
}