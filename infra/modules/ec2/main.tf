# EC2 모듈 main.tf

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  key_name               = var.key_name
  tags = {
    Name = var.instance_name
  }
}

resource "aws_eip" "web_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.instance_name}-eip"
  }
}

resource "aws_eip_association" "web_eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web_eip.id
}
