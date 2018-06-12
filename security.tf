###
### Security IP list for SSH management etc
###

### The opc_compute_security_ip_list resource creates and manages
### a security IP list in an Oracle Cloud Infrastructure Compute Classic identity domain.

resource "opc_compute_security_ip_list" "sec_ip_list_ssh_access" {
  name       = "sec_ip_list_ssh_access"
  ip_entries = ["84.241.194.88"]
}

resource "opc_compute_security_ip_list" "sec_ip_clients" {
  name       = "remote-management-clients"
  ip_entries = ["86.92.159.160", "198.184.231.254"]
}

resource "opc_compute_security_ip_list" "IP_Emiel_huis" {
  name       = "IP_Emiel_huis"
  ip_entries = ["86.92.159.160"]
}

###
### Security list for SSH management etc
###

## The opc_compute_security_list resource creates and manages
## a security list in an Oracle Cloud Infrastructure Compute Classic identity domain.

resource "opc_compute_security_list" "sec_list_INCOMING_TRAFFIC" {
  name                 = "sec_list_INCOMING_TRAFFIC"
  policy               = "permit"
  outbound_cidr_policy = "deny"
}

###
### Application definitions
###

resource "opc_compute_security_application" "ssh" {
  name     = "ssh"
  protocol = "tcp"
  dport    = "22"
}

###
### SEC_RULE: Actual firewall policy
###

resource "opc_compute_sec_rule" "sec_rule_INCOMING_TRAFFIC" {
  name             = "test_rule_INCOMING_TRAFFIC"
  source_list      = "seciplist:${opc_compute_security_ip_list.sec_ip_list_ssh_access.name}"
  destination_list = "seclist:${opc_compute_security_list.sec_list_INCOMING_TRAFFIC.name}"
  action           = "permit"
  application      = "${opc_compute_security_application.ssh.name}"
}


###
### Security associations
###

## The opc_compute_security_association resource creates and manages an association between
## an instance and a security list in an Oracle Cloud Infrastructure Compute Classic identity domain.

resource "opc_compute_security_association" "test_instance__sec_list__instance_cicd" {
  name    = "SA_instance_cicd"
  vcable  = "${opc_compute_instance.instance_cicd.vcable}"
  seclist = "${opc_compute_security_list.sec_list_INCOMING_TRAFFIC.name}"
}

resource "opc_compute_security_association" "test_instance__sec_list__instance_siebel" {
  name    = "SA_instance_siebel"
  vcable  = "${opc_compute_instance.instance_siebel.vcable}"
  seclist = "${opc_compute_security_list.sec_list_INCOMING_TRAFFIC.name}"
}

resource "opc_compute_security_association" "test_instance__sec_list__instance_siebel_configurator" {
  name    = "SA_instance_siebel_configurator"
  vcable  = "${opc_compute_instance.instance_siebel_configurator.vcable}"
  seclist = "${opc_compute_security_list.sec_list_INCOMING_TRAFFIC.name}"
}
