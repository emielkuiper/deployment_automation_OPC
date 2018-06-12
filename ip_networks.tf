###
### Additional IP Networks
###

resource "opc_compute_ip_network_exchange" "networkexchange1" {
  name        = "IPExchange_1"
  description = "IP Network Exchange 1"
}

resource "opc_compute_ip_network" "ip_network_backend_10-0-1-0_24" {
  name                = "10-0-1-0_24"
  description         = "IP subnet 10.0.1.0/24"
  ip_address_prefix   = "10.0.1.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.networkexchange1.name}"
  public_napt_enabled = false
  tags                = ["tag1", "tag2"]
}

resource "opc_compute_ip_network" "BE_1" {
  name                = "BE_1"
  description         = "IP subnet 192.168.101.0/24"
  ip_address_prefix   = "192.168.101.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.networkexchange1.name}"
  public_napt_enabled = false
  tags                = ["Backend", "Network_1"]
}
