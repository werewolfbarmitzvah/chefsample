# Create a VPC, subnet, a gateway, routing table, and rules for ingress traffic to 52.7.76.128
# In a real world example, most of these variables would be in a variables.tf file and anything sensitive masked
resource "aws_vpc" "vpc" {
  cidr_block           = "some ip address"
  tags = {
    Name = "some name"
    Env  = "some environment"
  }
}
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "some subnet ip address"
  map_public_ip_on_launch = "true"
tags = {
    Name = "some subnet name"
    Env  = "some environment"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
tags = {
    Name = "some gateway name"
    Env  = "some environment"
  }
}
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
route {
    cidr_block = "the gateway route"
    gateway_id = aws_internet_gateway.gw.id
  }
tags = {
    Name = "route table"
    env  = "some environment"
  }
}
resource "aws_default_security_group" "security_group" {
  name = "some security group name"
  vpc_id = aws_vpc.vpc.id
 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "Environment" = "some environment"
  }
}
resource "aws_instance" "test_instance" {
  ami           = "the 16.04 image"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_default_security_group.security_group.id]
  private_ip = "52.7.76.128"
  subnet_id  = "${aws_subnet.subnet.id}"
}