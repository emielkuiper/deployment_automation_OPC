# Storage volumes
resource "opc_compute_storage_volume" "sv_cicd_server" {
  name        = "storageVolume_CICD"
  description = "Storage volume for CICD Server"
  size        = 1000
  tags        = ["first", "second"]
  bootable    = false
}

resource "opc_compute_storage_volume" "sv_siebel_server" {
  name        = "storageVolume_Siebel"
  description = "Storage volume for Siebel Enterprise Server"
  size        = 1000
  tags        = ["first", "second"]
  bootable    = false
}

resource "opc_compute_storage_volume" "sv_siebel_configurator" {
  name        = "storageVolume_SiebelConfigurator"
  description = "Storage volume for Siebel Configurator Server"
  size        = 1000
  tags        = ["first", "second"]
  bootable    = false
}

###
### IP reservations
###

resource "opc_compute_ip_reservation" "ipreservation_cicd_server" {
  name        = "IP_CICD"
  parent_pool = "/oracle/public/ippool"
  permanent   = true
}

resource "opc_compute_ip_reservation" "ipreservation_siebel_server" {
  name        = "IP_Siebel"
  parent_pool = "/oracle/public/ippool"
  permanent   = true
}

resource "opc_compute_ip_reservation" "ipreservation_siebel_configurator" {
  name        = "IP_SiebelConfigurator"
  parent_pool = "/oracle/public/ippool"
  permanent   = true
}

###
### SSH keys
###

resource "opc_compute_ssh_key" "sshkey_voor_remote_access" {
  name = "admin_ssh_key"
  key  = "${file("~/.ssh/id_rsa.pub")}"
}

###
### Instances
###

resource "opc_compute_instance" "instance_cicd" {
  name       = "instance_CICD"
  shape      = "oc4"
  image_list = "/oracle/public/OL_7.2_UEKR3_x86_64"
  ssh_keys   = ["${opc_compute_ssh_key.sshkey_voor_remote_access.name}"]

  networking_info {
    index          = 0
    shared_network = true
    nat            = ["${opc_compute_ip_reservation.ipreservation_cicd_server.name}"]
  }

  storage {
    index  = 1
    volume = "${opc_compute_storage_volume.sv_cicd_server.name}"
  }
}

resource "opc_compute_instance" "instance_siebel" {
  name       = "instance_Siebel"
  shape      = "oc5"
  image_list = "/oracle/public/OL_7.2_UEKR3_x86_64"
  ssh_keys   = ["${opc_compute_ssh_key.sshkey_voor_remote_access.name}"]

  networking_info {
    index          = 0
    shared_network = true
    nat            = ["${opc_compute_ip_reservation.ipreservation_siebel_server.name}"]
  }

  storage {
    index  = 1
    volume = "${opc_compute_storage_volume.sv_siebel_server.name}"
  }
}

resource "opc_compute_instance" "instance_siebel_configurator" {
  name       = "instance_Siebel_configurator"
  shape      = "oc4"
  image_list = "/oracle/public/OL_7.2_UEKR3_x86_64"
  ssh_keys   = ["${opc_compute_ssh_key.sshkey_voor_remote_access.name}"]

  networking_info {
    index          = 0
    shared_network = true
    nat            = ["${opc_compute_ip_reservation.ipreservation_siebel_configurator.name}"]
  }

  storage {
    index  = 1
    volume = "${opc_compute_storage_volume.sv_siebel_configurator.name}"
  }
}

###
### Outputs
###

output "CICD_server_name" {
  value = "${opc_compute_instance.instance_cicd.name}"
}

output "CICD_public_ip" {
  value = "${opc_compute_ip_reservation.ipreservation_cicd_server.ip}"
}

output "Siebel_server_name" {
  value = "${opc_compute_instance.instance_siebel.name}"
}

output "Siebel_public_ip" {
  value = "${opc_compute_ip_reservation.ipreservation_siebel_server.ip}"
}

output "Siebel_configurator_name" {
  value = "${opc_compute_instance.instance_siebel_configurator.name}"
}

output "Siebel_configurator_public_ip" {
  value = "${opc_compute_ip_reservation.ipreservation_siebel_configurator.ip}"
}

###
### Ansible logical provider block
###

resource "ansible_host" "cicd" {
  inventory_hostname = "${opc_compute_ip_reservation.ipreservation_cicd_server.ip}"
  groups             = ["cicd"]

  vars {
    foo = "bar"
  }
}

resource "ansible_host" "siebel_server" {
  inventory_hostname = "${opc_compute_ip_reservation.ipreservation_siebel_server.ip}"
  groups             = ["siebel"]

  vars {
    foo = "bar"
  }
}

resource "ansible_host" "siebel_configurator" {
  inventory_hostname = "${opc_compute_ip_reservation.ipreservation_siebel_configurator.ip}"
  groups             = ["siebel"]

  vars {
    foo = "bar"
  }
}
