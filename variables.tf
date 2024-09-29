variable "vpc_cidr_block" {
  description = "CIDR block VPC"
  type        = string
  default     = "192.168.2.0/24"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 24))
    error_message = "O cidr_block precisa de um endereço IP /24 válido."
  }
}

variable "instance_type" {
  description = "Tipo da instância de teste"
  type        = string
  default     = "t2.nano"
}

variable "instance_name_prefix" {
  type        = string
  description = "Prefix for the names of the instances"
}

variable "instance_docker_count" {
  description = "The number of instances app to create"
  type        = number
  default     = 2
}

variable "ebs_block_device" {
  description = "list of volumes to attach on instances"
  type        = list(any)
}

variable "subnets_map" {
  type        = map(string)
  description = "Map of subnet IDs to distribute instances"
}

variable "create_private_subnets" {
  description = "Flag to create private subnets"
  type        = bool
  default     = false
}