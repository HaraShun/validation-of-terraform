#####################
# Terraform Provider
#####################
provider "aws" {
    region = "ap-northeast-1"
}


######
# VPC
######

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "Terraform VPC"
  }
}


###################
# Internet Gateway
###################
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw"
  }
}


#################
# Public Subnets
#################
resource "aws_subnet" "public_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1d"
  }
}

###############
# Routes Table
###############
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public-rt"
  }
}


###########################
# Public Subnet Association
###########################
resource "aws_route_table_association" "public_1a" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = "${aws_subnet.public_1c.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_1d" {
  subnet_id      = "${aws_subnet.public_1d.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
