provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
  token      = var.token
}

resource "consul_intention" "igw-allow" {
  source_name      = "ingress-gateway"
  destination_name = "frontend"
  action           = "allow"
}

resource "consul_intention" "fe-api-allow" {
    source_name      = "frontend"
    destination_name = "api"
    action           = "allow"
  }

resource "consul_intention" "api-db-allow" {
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

resource "consul_config_entry" "ingress" {
    kind = "ingress-gateway"
    name = "ingress-gateway"

    config_json = jsonencode({
      Listeners = [
   {
     Port = 8080
     Protocol = "http"
     Services = [
       {
         Name = "frontend"
         Hosts = ["*"]
       }
     ]
   }
  ]
  })
  }
