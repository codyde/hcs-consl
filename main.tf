provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
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