locals {
  # Extraindo as chaves do mapa de sub-redes
  subnet_keys = keys(var.subnets_map)

  # Criando uma lista de instâncias, alternando entre as sub-redes
  instances = [
    for i in range(var.instance_web_count) : {
      name      = "${var.instance_name_prefix}${i + 1}"
      subnet_id = var.subnets_map[local.subnet_keys[i % length(local.subnet_keys)]]
    }
  ]
}