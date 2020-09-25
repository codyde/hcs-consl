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

resource "consul_service" "redis" {
  name = "redis"
  node = "redis"
  port = 6379

  check {
    check_id                          = "service:redis1"
    name                              = "Redis health check"
    status                            = "passing"
    http                              = "https://www.hashicorptest.com"
    tls_skip_verify                   = false
    method                            = "PUT"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30s"

    header {
      name  = "foo"
      value = ["test"]
    }

    header {
      name  = "bar"
      value = ["test"]
    }
  }
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
