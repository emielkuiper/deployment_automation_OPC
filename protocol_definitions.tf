###
### Protocol definitions
###

resource "opc_compute_security_protocol" "ICMP_ALL" {
  name        = "ICMP_ALL"
  ip_protocol = "icmp"
}

resource "opc_compute_security_protocol" "SSH" {
  name        = "SSH"
  src_ports   = ["0-65535"]
  dst_ports   = ["22"]
  ip_protocol = "tcp"
}
