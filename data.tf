data "aws_ami" "ubuntu-docker" {
  most_recent = true

  filter {
    name   = "name"
    values = ["base-docker-ubuntu*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["654654481221"]
}