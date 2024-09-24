output "vpc_terraform" {
  value = aws_vpc.vpc-terraform
}

output "subnets_map" {
  value = {
    "subnet-east1a" = aws_subnet.subnet-public-terraform-east1a.id,
    "subnet-east1c" = aws_subnet.subnet-public-terraform-east1c.id
  }
}