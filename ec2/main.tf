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
  vpc_security_group_ids = [aws_security_group.SnetFullAccess.id, aws_security_group.alb-docker-instances.id]
  subnet_id              = each.value.subnet_id
  tags = {
    Name = each.value.name
  }
}