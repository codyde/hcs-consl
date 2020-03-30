provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
}


data "template_file" "init" {
  template = "${file("website.tmpl")}"
  vars = {
    cardHeader = var.cardHeader
    cardText = var.cardText
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