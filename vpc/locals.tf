locals {
  subnets_map = {
    "subnet-east1a" = aws_subnet.subnet-public-terraform-east1a.id,
    "subnet-east1c" = aws_subnet.subnet-public-terraform-east1c.id
  }
}