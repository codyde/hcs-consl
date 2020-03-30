variable "cluster" {
    description = "variable for Consul Cluster"
    default = "127.0.0.1:8500"
}

variable "consuldc" {
    description = "variable for the Consul Cluster Datacenter"
    default = "dc01"
}

variable "cardHeader" {
  description = "Text for the card header"
}

variable "cardText" {
  description = "Text for the description of a card"
}