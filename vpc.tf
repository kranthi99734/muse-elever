#create vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_muse_elever[0]
 
  tags = {
    Name = "MyVPC-Muse Elever"
  }
}

#creating public subnet
 
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    name = "muse-elever-public_sub"
  }
}

#creating private subnets
 
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    name = "muse-elever-private_subnet"
  }
}
 
 #create routetable
 resource "aws_route_table" "route_table_muse_elever" {
  vpc_id = aws_vpc.my_vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
 
  tags = {
    Name = "muse_elever_route_table"
  }
}
 
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.route_table_muse_elever.id
}
 
resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.route_table_muse_elever.id
}

#create internetgateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
   tags = {
    Name = "my-internet-gateway"
  }
 
 
  }

  #creating acl

  resource "aws_network_acl" "muse_elever_public_nacl" {
  count = length(aws_subnet.public_subnets)

  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.public_subnets[count.index].id]
}

resource "aws_network_acl" "muse_elever_private_nacl" {
  count = length(aws_subnet.private_subnets)

  vpc_id = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.private_subnets[count.index].id]
}

resource "aws_network_acl_rule" "private_nacl_ingress_rule" {
  count = length(aws_subnet.public_subnets)

  network_acl_id = aws_network_acl.muse_elever_private_nacl[count.index].id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_subnet.public_subnets[count.index].cidr_block
  from_port      = 1024
  to_port        = 65535
}
#creating security groups

resource "aws_security_group" "sg-muse_elever" {
  name        = "muse-elever-sg"
  vpc_id      = aws_vpc.my_vpc.id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 22
    to_port     = 22
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