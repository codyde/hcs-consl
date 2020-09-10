provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
  token      = var.token
}

resource "consul_intention" "frontend" {
  source_name      = "frontend"
  destination_name = "api"
  action           = "allow"
}
