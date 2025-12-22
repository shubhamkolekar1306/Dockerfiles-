
########################
#Provider
#########################
provider "aws" {
region = "ap-south-1"

}
########################
#VPC
#########################
resource  "aws_vpc" "my_vpc" {
cidr_block = "10.0.0.0/16"

tags = {
Name = "my_vpc"

}

}
########################
#internet_gateway
#########################
resource "aws_internet_gateway" "my_igw" {
vpc_id = aws_vpc.my_vpc.id

tags = {

Name = "my_igw"

}

}
########################
#Public_subnet
#########################
resource "aws_subnet" "public_sub_1" {
vpc_id = aws_vpc.my_vpc.id
cidr_block="10.0.1.0/24"
availability_zone = "ap-south-1a"
tags = {
Name = "public_subnet_1"
}

}

resource "aws_subnet" "public_sub_2" {
vpc_id = aws_vpc.my_vpc.id
cidr_block="10.0.2.0/24"
availability_zone = "ap-south-1b"
tags = {
Name = "public_subnet_2"

}

}

########################
#Private_subnets
#########################

resource "aws_subnet" "private_sub_1" {
vpc_id            = aws_vpc.my_vpc.id
cidr_block        = "10.0.3.0/24"
availability_zone = "ap-south-1a"
tags = {
Name = "private_subnet_1"
 }

}

resource "aws_subnet" "private_sub_2" {
vpc_id            = aws_vpc.my_vpc.id
cidr_block        = "10.0.4.0/24"
availability_zone = "ap-south-1b"
tags = {
Name = "private_subnet_2"
 
 }

}

########################
#Public Route_table 
#########################

resource "aws_route_table" "public_route_table" {
vpc_id = aws_vpc.my_vpc.id

tags = {

Name = "public_route_table"

  }

}

resource "aws_route" "public_internet_access" {
route_table_id         = aws_route_table.public_route_table.id
destination_cidr_block = "0.0.0.0/0"
gateway_id             = aws_internet_gateway.my_igw.id

}

resource "aws_route_table_association" "public_sub_1" {
subnet_id      =  aws_subnet.public_sub_1.id
route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_sub_2" {
subnet_id      =  aws_subnet.public_sub_2.id
route_table_id = aws_route_table.public_route_table.id

}

########################
# Private Route Table
#########################
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_sub_1_assoc" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_sub_2_assoc" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.private_route_table.id
}
####################
#security groups
####################
resource "aws_security_group" "allow_all" {
  name        = "allow_all_sg"
  description = "Security group with full ingress and egress"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow ALL inbound traffic
  ingress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"   # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ALL outbound traffic
  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_sg"
  }
}

