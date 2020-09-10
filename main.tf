provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
  token      = var.token
}

resource "consul_intention" "api-allow" {
  source_name      = "frontend"
  datacenter       = var.consuldc
  destination_name = "pyapi"
  action           = "allow"
}
