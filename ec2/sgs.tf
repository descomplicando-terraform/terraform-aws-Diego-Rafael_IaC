resource "aws_security_group" "vpc-terraform-all-traffic" {
  name        = "vpc-terraform"
  description = "vpc-terraform-all-traffic"
  vpc_id      = var.vpc_terraform.id
  ingress {
    description = "vpc-terraform-all-traffic"
    cidr_blocks = [var.vpc_terraform.cidr_block]
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

# Criar o grupo de segurança para o Load Balancer
resource "aws_security_group" "alb-docker-instances" {
  name        = "alb-docker-instances"
  description = "Liberar o trafego entre as instancias EC2 e o LB"
  vpc_id      = var.vpc_terraform.id

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

  tags = {
    Name = "alb-docker-instances"
  }
}

resource "aws_security_group" "SnetFullAccess" {
  name        = "SnetFullAccess"
  description = "Todo o trafego Snet"
  vpc_id      = var.vpc_terraform.id
  ingress {
    description = "Todo o trafego Snet"
    cidr_blocks = ["177.37.240.64/32", "54.197.94.222/32"]
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