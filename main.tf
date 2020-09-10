provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
}
