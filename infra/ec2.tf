# ---------------------
# EC2 Key pair setting
# ---------------------
variable "key_name" {
  default = "my-tech-blog_rsa"
}

resource "tls_private_key" "tech-blog-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  public_key_file  = "/Users/matsushima/.ssh/${var.key_name}.pub"
  private_key_file = "/Users/matsushima/.ssh/${var.key_name}"
}

resource "local_file" "tech-blog_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.tech-blog-key.private_key_pem
}

resource "aws_key_pair" "tech-blog_keypair" {
  key_name   = var.key_name
  public_key = tls_private_key.tech-blog-key.public_key_openssh
}

# ---------------------
# EC2 Instance setting
# ---------------------
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "tech-blog-server" {
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = var.az_a
  vpc_security_group_ids      = [aws_security_group.my-tech-blog_sg.id]
  subnet_id                   = aws_subnet.my-tech-blog_subnet.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name = "tech-blog-server"
  }
}

# ---------------------
# Elastic IP setting
# ---------------------
resource "aws_eip" "tech-blog-eip" {
  instance = aws_instance.tech-blog-server.id
  domain   = "vpc"
}


