provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
}


data "template_file" "init" {
  template = "${file("website.tmpl")}"
  vars = {
    cardHeader = "Consul on Azure Demo"
    cardText = "This is a demo of HashiCorp Consul on Azure"
  }
}

resource "consul_keys" "app" {
  key {
    path  = "demoapp/intro/text"
    value = data.template_file.init.rendered
  }
}

resource "consul_intention" "default-deny" {
  source_name      = "*"
  destination_name = "*"
  action           = "deny"
}

resource "consul_intention" "api-allow" {
  source_name      = "frontend-vm"
  destination_name = "pyapi-vm"
  action           = "allow"
}

resource "consul_intention" "db-allow" {
  source_name      = "pyapi-vm"
  destination_name = "db-vm"
  action           = "allow"
}