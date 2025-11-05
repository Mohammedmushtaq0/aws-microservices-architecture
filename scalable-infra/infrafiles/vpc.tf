# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "product_v1" {
  cidr_block       = "10.0.0.0/16" # AWS best practice private IP range
  instance_tenancy = "default"

  tags = {
    Name = "product-v1"
  }
}

# -------------------------
# Public Subnets
# -------------------------
resource "aws_subnet" "product_v1_subnet_1a_public" {
  vpc_id                  = aws_vpc.product_v1.id
  cidr_block              = "10.0.1.0/24" # Public subnet
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "product-v1-subnet-1a-public"
  }
}

resource "aws_subnet" "product_v1_subnet_1b_public" {
  vpc_id                  = aws_vpc.product_v1.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "product-v1-subnet-1b-public"
  }
}

# -------------------------
# Private Subnets
# -------------------------
resource "aws_subnet" "product_v1_subnet_1b_private" {
  vpc_id            = aws_vpc.product_v1.id
  cidr_block        = "10.0.101.0/24" # Private subnet
  availability_zone = "ap-south-1b"

  tags = {
    Name = "product-v1-subnet-1b-private"
  }
}

resource "aws_subnet" "product_v1_subnet_1a_private" {
  vpc_id            = aws_vpc.product_v1.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "product-v1-subnet-1a-private"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "product_v1_igw" {
  vpc_id = aws_vpc.product_v1.id

  tags = {
    Name = "product-v1-igw"
  }
}

# -------------------------
# Public Route Table
# -------------------------
resource "aws_route_table" "product_v1_rt" {
  vpc_id = aws_vpc.product_v1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.product_v1_igw.id
  }

  tags = {
    Name = "product-v1-rt"
  }
}

resource "aws_route_table_association" "product_v1_rt_assoc_public" {
  for_each = {
    subnet1 = aws_subnet.product_v1_subnet_1a_public.id
    subnet2 = aws_subnet.product_v1_subnet_1b_public.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.product_v1_rt.id
}

# -------------------------
# NAT Gateway
# -------------------------
resource "aws_eip" "product_v1_eip" {
  domain = "vpc"
  tags = {
    Name = "product-v1-eip"
  }
}

resource "aws_nat_gateway" "product_v1_nat_gw" {
  allocation_id = aws_eip.product_v1_eip.id
  subnet_id     = aws_subnet.product_v1_subnet_1a_public.id

  tags = {
    Name = "product-v1-nat-gw"
  }

  depends_on = [aws_internet_gateway.product_v1_igw]
}

# -------------------------
# Private Route Table
# -------------------------
resource "aws_route_table" "product_v1_rt_private" {
  vpc_id = aws_vpc.product_v1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.product_v1_nat_gw.id
  }

  tags = {
    Name = "product-v1-rt-private"
  }
}

resource "aws_route_table_association" "product_v1_rt_assoc_private" {
  for_each = {
    subnet3 = aws_subnet.product_v1_subnet_1b_private.id
    subnet4 = aws_subnet.product_v1_subnet_1a_private.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.product_v1_rt_private.id
}

# -------------------------
# NACL for Public Subnet (example)
# -------------------------
resource "aws_network_acl" "product_v1_nacl_1" {
  vpc_id = aws_vpc.product_v1.id

  ingress {
    rule_no    = 100
    protocol   = "6" # TCP
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 100
    protocol   = "6"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "product-v1-nacl-1"
  }
}

# -------------------------
# Security Groups
# -------------------------
resource "aws_security_group" "product_v1_sg" {
  name        = "product-v1-sg"
  description = "Allow HTTP, HTTPS and SSH"
  vpc_id      = aws_vpc.product_v1.id

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

  #all ingress trafic allowed 

  ingress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

# -------------------------
# ALB Security Group
# -------------------------
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.product_v1.id

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

  tags = {
    Name = "alb-security-group"
  }
}
