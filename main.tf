provider "consul" {
  address    = "https://11ea6ac5-4e8c-c9e2-8f8b-0242ac11000a.consul.az.hashicorp.cloud:443"
  datacenter = "consulaz"
}


data "template_file" "init" {
  template = "${file("website.tmpl")}"
  vars = {
    cardHeader = "HashiCorp Consul Service on Azure - VM <> VM Mesh Demo"
    cardText = "Our application is designed to demonstrate connectivity between multiple tiers in a Service Mesh running with Consul"
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
  source_name      = "nginx"
  destination_name = "pyapi-vm"
  action           = "allow"
}

resource "consul_intention" "db-allow" {
  source_name      = "pyapi-vm"
  destination_name = "db-vm"
  action           = "allow"
}