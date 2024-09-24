resource "aws_security_group" "vpc-terraform-all-traffic" {
  name        = "vpc-terraform"
  description = "vpc-terraform-all-traffic"
  vpc_id      = module.vpc.vpc-terraform.id
  ingress {
    description = "vpc-terraform-all-traffic"
    cidr_blocks = [module.vpc.vpc-terraform.cidr_block]
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