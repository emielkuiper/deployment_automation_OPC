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

PS: before you use this you might want to disable stricthostchecking in ansible.cfg.

Make sure that in /etc/ansible/ansible.cfg the folowing lines are present:

```
[defaults]
host_key_checking = False
```

Because the destination addresses Ansible connects to could change with every deployment these addresses will most certainly not be present in the known_hosts file.

By disabling these checks there is no need to confirm each new exception onto the known_hosts file.


## Terraform-provider-ansible
The "terraform-provider-ansible" project has created a so-called 'virtual provider'.
This virtual provider consists of a binary that has to be placed in the usual terraform
provider dir.

See https://www.terraform.io/docs/configuration/providers.html for details.

Or use below mentioned script to install on 64-bit Linux:

```
/bin/sh scripts/install_terraform_provider_ansible.sh
```

## Terraform-inventory
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


## Terraform cloud credentials
The main.tf file consists of all the config that is needed to spin up 3 machines in
the Oracle OPC cloud (Oracle Compute Cloud Classic).

The credentials that should be used are of course not mentioned in this main.tf file.

To provide your terraform setup with the necessary credentials, please enter the directory
where all of the .tf files are placed, and create a file "secret_credentials.tf".

The contents of this file should look like this:

```
provider "opc" {
  user            = "<your-oracle-cloud-username_or_email-address>"
  password        = "<your-oracle-cloud-password>"
  identity_domain = "<your-9-digit-identity_domain>"

  endpoint = "<your API endpoint, for example: https://compute.eucom-north-1.oraclecloud.com/>"
}
```

Terraform, before it begins, concatenates the contents of ALL files ending with .tf.

So, the content of your newly created credential file will be automatically processed.
In fact, you can give the credential file any name you want as long as it ends with the extension .tf

The reason why secret_credentials.tf was chosen in this example is because that filename is explicitly
excluded from git commits and pushes so it will not accidentally end up on GitHub storage.
