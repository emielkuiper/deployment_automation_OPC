# Introduction

This project accompanies the following 3 projects:

* https://github.com/louwersj/deployment_automation_SiebelIndustryApplications
* https://github.com/louwersj/deployment_automation_OraclePolicyAutomation
* https://github.com/louwersj/deployment_automation_WebLogicServer

The project deployment_automation_OPC will serve as a set of (Ansible) scripts,
Terraform files etc to initialize an IaaS environment on the Oracle Public Cloud.


# Terraform & Ansible

## Terraform Ansible provider
Terraform itself currently does not have direct support for Ansible as a terraform-provider.

Therefore, this project makes use of the following two pre-existing Github projects:

* https://github.com/nbering/terraform-provider-ansible
* https://github.com/nbering/terraform-inventory


## terraform-provider-ansible
The "terraform-provider-ansible" project has created a so-called 'virtual provider'.
This virtual provider consists of a binary that has to be placed in the usual terraform
provider dir.

See https://www.terraform.io/docs/configuration/providers.html for details.

Or use below mentioned script to install on 64-bit Linux:

```
/bin/sh scripts/install_terraform_provider_ansible.sh
```

## terraform-inventory
The "terraform-inventory" project consists of a "dynamic inventory" script that can be
used by Ansible to create a valid inventory file after the terraform actions have completed.

Install the terraform.py script by using the following script:

```
/bin/sh scripts/install_terraform_inventory.sh
```


Example usage:

```
$ ansible-playbook -i inventory/terraform.py playbook.yml
```
