#Map para criacao das instancias
locals {
  public_subnets = {
    "subnet-east1a-public" = aws_subnet.subnet-public-terraform-east1a.id,
    "subnet-east1c-public" = aws_subnet.subnet-public-terraform-east1c.id,
  }

  private_subnets = var.create_private_subnets ? {
    "subnet-east1a-private" = aws_subnet.subnet-private-terraform-east1a[0].id,
    "subnet-east1c-private" = aws_subnet.subnet-private-terraform-east1c[0].id
  } : {}

  subnets_map = merge(local.public_subnets, local.private_subnets)
}

# Extraindo as chaves do mapa de sub-redes para criar instâncias alternando nas sub-redes
locals {
  subnet_keys = keys(var.subnets_map)
  instances = [
    for i in range(var.instance_docker_count) : {
      name      = "${var.instance_name_prefix}${i + 1}"
      subnet_id = var.subnets_map[local.subnet_keys[i % length(local.subnet_keys)]]
    }
  ]
}

# Criacao da VPC
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc-terraform" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Criando tabela de rotas default 
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

# Associando tabela de rotas a vpc
resource "aws_main_route_table_association" "vpc-terraform" {
  vpc_id         = aws_vpc.vpc-terraform.id
  route_table_id = aws_route_table.vpc-terraform.id
}

# Criando o internet gateway para as redes publicas
resource "aws_internet_gateway" "vpc-terraform-igw" {
  vpc_id = aws_vpc.vpc-terraform.id
}

# Criando as subnets de forma dinamica
resource "aws_subnet" "subnet-public-terraform-east1a" {
  vpc_id            = aws_vpc.vpc-terraform.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 3, 0)
}

resource "aws_subnet" "subnet-public-terraform-east1c" {
  vpc_id            = aws_vpc.vpc-terraform.id
  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 3, 2)
}

resource "aws_subnet" "subnet-private-terraform-east1a" {
  count             = var.create_private_subnets ? 1 : 0
  vpc_id            = aws_vpc.vpc-terraform.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 3, 1)
}

resource "aws_subnet" "subnet-private-terraform-east1c" {
  count             = var.create_private_subnets ? 1 : 0
  vpc_id            = aws_vpc.vpc-terraform.id
  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.vpc-terraform.cidr_block, 3, 3)
}

# Associando as subnets criadas a tabela de rotas
resource "aws_route_table_association" "vpc-terraform" {
  for_each = local.subnets_map

  subnet_id      = each.value
  route_table_id = aws_route_table.vpc-terraform.id
}


# Criacao das Instancias EC2
resource "aws_instance" "docker" {
  for_each = { for instance in local.instances : instance.name => instance }

  ami                         = data.aws_ami.ubuntu-docker.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    iterator = ebs_docker
    content {
      device_name = ebs_docker.value["device_name_root"]
      volume_type = "gp3"
      volume_size = ebs_docker.value["volume_size_docker"]
      iops        = 3000
      throughput  = 125
    }
  }
  vpc_security_group_ids = [aws_security_group.vpc-terraform-all-traffic.id, aws_security_group.alb-docker-instances.id]
  subnet_id              = each.value.subnet_id
}

# Criacao do Application Load Balancer 
resource "aws_lb" "docker-instances" {
  name               = "elb-docker-instances"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-docker-instances.id]
  subnets            = values(var.subnets_map)
}

# Criacao do Listener para o Application Load Balancer
resource "aws_lb_listener" "http-docker-instances" {
  load_balancer_arn = aws_lb.docker-instances.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-docker-instances.arn
  }

  depends_on = [aws_lb_target_group.tg-docker-instances]
}

# Criacao do Target Group para as instancias
resource "aws_lb_target_group" "tg-docker-instances" {
  name        = "tg-docker-instances"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-terraform.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Registrando as instâncias no Target Group
resource "aws_lb_target_group_attachment" "docker-instances" {
  for_each = aws_instance.docker

  target_group_arn = aws_lb_target_group.tg-docker-instances.arn
  target_id        = each.value.id
  port             = 80

  depends_on = [aws_lb_target_group.tg-docker-instances]
}


# Criacao dos SGs
# Todo o trafego para a VPC
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
}

# SG HTTP Local Load Balancer
resource "aws_security_group" "alb-docker-instances" {
  name        = "alb-docker-instances"
  description = "Liberar o trafego entre as instancias EC2 e o LB"
  vpc_id      = aws_vpc.vpc-terraform.id

  ingress {
    description = "Allow HTTP traffic Local"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["177.37.240.64/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }
}