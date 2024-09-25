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