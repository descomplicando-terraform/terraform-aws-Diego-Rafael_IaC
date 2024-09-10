module "ec2" {
  source               = "./modules/ec2"
  subnets_map          = module.vpc.subnets_map
  instance_name_prefix = "web"
  instance_web_count   = 2
  instance_type        = "t2.nano"
  ebs_block_device = [
    {
      device_name_root = "/dev/sda1"
      volume_size_web  = 8
    }
  ]
}


module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "192.168.2.0/24"
}
