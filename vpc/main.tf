#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc-terraform" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-terraform"
  }
}

resource "aws_route_table" "vpc-terraform" {
  depends_on = [aws_internet_gateway.vpc-terraform-igw]
  vpc_id     = aws_vpc.vpc-terraform.id


  route {
    cidr_block = aws_vpc.vpc-terraform.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-terraform-igw.id
  }
}

resource "aws_main_route_table_association" "vpc-terraform" {
  vpc_id         = aws_vpc.vpc-terraform.id
  route_table_id = aws_route_table.vpc-terraform.id
}

resource "aws_internet_gateway" "vpc-terraform-igw" {
  vpc_id = aws_vpc.vpc-terraform.id

  tags = {
    Name = "vpc-terraform-igw"
  }
}

resource "aws_subnet" "subnet-public-terraform-east1a" {
  vpc_id            = aws_vpc.vpc-terraform.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 3, 0)

  tags = {
    Name = "subnet-public-terraform-east-1a"
  }
}

resource "aws_subnet" "subnet-public-terraform-east1c" {
  vpc_id            = aws_vpc.vpc-terraform.id
  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 3, 2)


  tags = {
    Name = "subnet-public-terraform-east-1c"
  }
}

resource "aws_route_table_association" "vpc-terraform" {
  for_each = local.subnets_map

  subnet_id      = each.value
  route_table_id = aws_route_table.vpc-terraform.id
}