#ec2

resource "aws_instance" "server" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id = var.sn
  security_groups = [var.sg]
  key_name        = "ravinakey"

  tags = {
    Name = "myserver"
  }
}