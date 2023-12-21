terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIATZDUYTLC4RJYWO4Z"
  secret_key = "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"
}

resource "aws_instance" "s1" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.demo-subnet.id
  vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]

  tags = {
    Name = "Server1"
  }
}

## Create VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.10.0.0/16"
}


## Create subnet

resource "aws_subnet" "demo-subnet" {
  vpc_id     =  aws_vpc.demo-vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "Demo Subet"
  }
}


## Create internet Gateway


resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo GW"
  }
}

## Create Route Table

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

  tags = {
    Name = "DemoRTB"
  }
}


## Demo Route Table Association

resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

## Create Security Group


resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
