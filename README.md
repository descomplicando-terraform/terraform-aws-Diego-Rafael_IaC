## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.68.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.docker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.vpc-terraform-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_lb.docker-instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http-docker-instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.tg-docker-instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.docker-instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_main_route_table_association.vpc-terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | resource |
| [aws_route_table.vpc-terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.vpc-terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.alb-docker-instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc-terraform-all-traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.subnet-private-terraform-east1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnet-private-terraform-east1c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnet-public-terraform-east1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnet-public-terraform-east1c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc-terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.ubuntu-docker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_private_subnets"></a> [create\_private\_subnets](#input\_create\_private\_subnets) | Flag to create private subnets | `bool` | `false` | no |
| <a name="input_ebs_block_device"></a> [ebs\_block\_device](#input\_ebs\_block\_device) | list of volumes to attach on instances | `list(any)` | n/a | yes |
| <a name="input_instance_docker_count"></a> [instance\_docker\_count](#input\_instance\_docker\_count) | The number of instances app to create | `number` | `2` | no |
| <a name="input_instance_name_prefix"></a> [instance\_name\_prefix](#input\_instance\_name\_prefix) | Prefix for the names of the instances | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Tipo da instância de teste | `string` | `"t2.nano"` | no |
| <a name="input_subnets_map"></a> [subnets\_map](#input\_subnets\_map) | Map of subnet IDs to distribute instances | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block VPC | `string` | `"192.168.2.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_docker_private_ips"></a> [docker\_private\_ips](#output\_docker\_private\_ips) | IPs Privados das instâncias docker |
| <a name="output_docker_public_ips"></a> [docker\_public\_ips](#output\_docker\_public\_ips) | IPs Publicos das instâncias docker |
| <a name="output_subnets_map"></a> [subnets\_map](#output\_subnets\_map) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | n/a |
