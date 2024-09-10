# Terraform-AWS-IaC
Criação do MVP para utilização de IaC via terraform

## Apresentação do projeto
Projeto Teste para utilização de infraestrutura como código onde é possível criar um cenário de testes a partir do zero, consistindo no deploy de toda a infraestrutura necessária, incluindo VPCs, Subnets, SGs e EC2.

## Utilização do projeto

- Definir o CIDR da VPC
- Definir a quantidade de instâncias web e o tipo da instância
- Definir os volumes a serem criados, respeitando o tipo e tamanho do volume

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./modules/ec2 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
