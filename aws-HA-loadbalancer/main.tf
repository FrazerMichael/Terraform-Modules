resource "aws_lauch_configuration" "ec2-cluser" {
    image_id = "ami-06e46074ae430fba6"
    instance_type = "t2.micro"
    security_groups = [var.sg-id]
    user_data       = var.user-data
    
    lifecycle {
        create_before_destroy = true
    }
}