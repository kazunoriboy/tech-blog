# ---------------------
# VPC settings
# ---------------------
resource "aws_vpc" "my-tech-blog_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "my-tech-blog_vpc"
  }
}

# ---------------------
# Subnet settings
# ---------------------
resource "aws_subnet" "my-tech-blog_subnet" {
  vpc_id            = aws_vpc.my-tech-blog_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az_a

  tags = {
    Name = "my-tech-blog_subnet"
  }
}

# ---------------------
# Internet Gateway settings
# ---------------------
resource "aws_internet_gateway" "my-tech-blog_igw" {
  vpc_id = aws_vpc.my-tech-blog_vpc.id

  tags = {
    Name = "my-tech-blog_igw"
  }
}

# ---------------------
# Route Table settings
# ---------------------
resource "aws_route_table" "my-tech-blog_rt" {
  vpc_id = aws_vpc.my-tech-blog_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-tech-blog_igw.id
  }
  tags = {
    Name = "my-tech-blog_rt"
  }
}

# ---------------------
# Security Group settings
# ---------------------
data "http" "ifconfig" {
  url = "http://ipv4.icanhazip.com/"
}

variable "allowed_cidr" {
  default = null
}

locals {
  myip         = chomp(data.http.ifconfig.response_body)
  allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

resource "aws_security_group" "my-tech-blog_sg" {
  name        = "my-tech-blog_sg"
  description = "my-tech-blog_sg"
  vpc_id      = aws_vpc.my-tech-blog_vpc.id

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}







