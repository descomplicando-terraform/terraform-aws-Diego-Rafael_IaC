#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc-terraform" {
  cidr_block           = "192.168.1.0/24"
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

resource "aws_security_group" "vpc-terraform-all-traffic" {
  name        = "vpc-terraform"
  description = "vpc-terraform-all-traffic"
  vpc_id      = aws_vpc.vpc-terraform.id

  ingress {
    description = "vpc-terraform-all-traffic"
    cidr_blocks = [aws_vpc.vpc-terraform.cidr_block]
    protocol    = "-1"
    to_port     = 0
    from_port   = 0
  }

  egress {
    description = "egress-all-traffic"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
    to_port     = 0
    from_port   = 0
  }

  tags = {
    Name = "vpc-terraform"
  }
}

resource "aws_route_table_association" "vpc-terraform" {
  for_each = toset([aws_subnet.subnet-public-terraform-east1a.id, aws_subnet.subnet-public-terraform-east1c.id])

  subnet_id      = each.key
  route_table_id = aws_route_table.vpc-terraform.id
}



/*
resource "aws_instance" "web1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
  subnet_id     = aws_subnet.subnet-public-terraform-east1a.id
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = 8
    iops        = 3000
    throughput  = 125
  }

  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
  subnet_id     = aws_subnet.subnet-public-terraform-east1c.id
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = 8
    iops        = 3000
    throughput  = 125
  }

  tags = {
    Name = "web2"
  }
}

resource "aws_instance" "db1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
  subnet_id     = aws_subnet.subnet-public-terraform-east1c.id
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = 10
    iops        = 3000
    throughput  = 125
  }

  tags = {
    Name = "db1"
  }
}*/