provider "consul" {
  address    = var.cluster
  datacenter = var.consuldc
  token      = var.token
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

resource "consul_config_entry" "frontend-v2" {
      name = "frontend-v2"
      kind = "service-defaults"

      config_json = jsonencode({
        Protocol    = "http"
      })
    }

resource "consul_config_entry" "fe-splitter" {
    kind = "service-splitter"
    name = consul_config_entry.frontend.name

    config_json = jsonencode({
      Splits = [
    {
     Weight  = 10
    },
    {
     Weight  = 90
      Service = "frontend-v2"
    }
  ]
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
