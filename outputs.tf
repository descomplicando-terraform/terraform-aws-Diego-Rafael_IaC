output "vpc" {
  value = aws_vpc.vpc-terraform
}

output "subnets_map" {
  value = {
    "subnet-east1a" = aws_subnet.subnet-public-terraform-east1a.id,
    "subnet-east1c" = aws_subnet.subnet-public-terraform-east1c.id
  }
}

output "docker_public_ips" {
  description = "IPs Publicos das instâncias docker"
  value = {
    for name, instance in aws_instance.docker : name => instance.public_ip
  }
}

output "docker_private_ips" {
  description = "IPs Privados das instâncias docker"
  value = {
    for name, instance in aws_instance.docker : name => instance.private_ip
  }
}