provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
  token      = var.token
}

resource "consul_namespace" "production" {
  name        = "production"
  description = "Production namespace"

 }
