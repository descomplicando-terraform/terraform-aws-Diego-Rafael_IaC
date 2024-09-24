variable "instance_type" {
  description = "Tipo da instância de teste"
  type        = string
  default     = "t2.nano"
}

variable "instance_name_prefix" {
  type        = string
  description = "Prefix for the names of the instances"
}

variable "instance_web_count" {
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