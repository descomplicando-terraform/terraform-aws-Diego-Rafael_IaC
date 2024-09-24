resource "aws_instance" "web" {
  for_each = { for instance in local.instances : instance.name => instance }

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    iterator = ebs_web
    content {
      device_name = ebs_web.value["device_name_root"]
      volume_type = "gp3"
      volume_size = ebs_web.value["volume_size_web"]
      iops        = 3000
      throughput  = 125
    }
  }
  subnet_id = each.value.subnet_id
  tags = {
    Name = each.value.name
  }
}