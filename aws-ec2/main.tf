data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "ec2-instance" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.chassis
  key_name        = "S144Key"
  subnet_id       = var.SN-id
  security_groups = [var.sg-id]
  tags            = { Name = "${var.cluster}-ec2-${var.private == true ? "private" : "public"}-${var.name}" }
}