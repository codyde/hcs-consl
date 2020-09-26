provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
  token      = var.token
}

resource "consul_namespace" "production" {
  name        = "production"
  description = "Production namespace"

  meta = {
    foo = "bar"
  }
}

resource "consul_service" "hashi" {
  name    = "hashi"
  node    = "${consul_node.compute.name}"
  port    = 80
  tags    = ["hashi"]
  check {
    check_id                          = "service:HashiCorp"
    name                              = "HashiCorp health check"
    http                              = "https://www.hashicorp.com"
    tls_skip_verify                   = false
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
  }
}

resource "consul_node" "compute" {
  name    = "compute-hashi"
  address = "www.hashicorp.com"
  }

resource "consul_intention" "api-allow" {
  source_name      = "frontend"
  destination_name = "api"
  action           = "allow"
}

resource "consul_intention" "db-allow" {
  source_name      = "api"
  destination_name = "db"
  action           = "allow"
}

resource "consul_config_entry" "frontend" {
  name = "frontend"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "ingress_gateway" {
    name = "hcs-igw"
    kind = "ingress-gateway"

    config_json = jsonencode({
        Listeners = [{
            Port     = 8080
            Protocol = "http"
            Services = [
     {
       Name = consul_config_entry.frontend.name
       Hosts = ["*"]
     }
   ]
            
        }]
    })
}
