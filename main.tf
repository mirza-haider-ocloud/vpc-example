

provider "aws" {
    region = "us-east-2"
}


variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_a_cidr" { 
    default = "10.0.1.0/24" 
}
variable "private_subnet_a_cidr" { 
    default = "10.0.2.0/24" 
}
variable "az1" { 
    default = "us-east-2a" 
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-new-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_a_cidr
  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  tags = {
    Name = "private-a"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# resource "aws_instance" "vpc-example" {
#   ami = "ami-0c3b809fcf2445b6a"
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.public_a.id
#   tags = {
#     Name = "vpc-example"
#   }
#   user_data_replace_on_change = true
# }