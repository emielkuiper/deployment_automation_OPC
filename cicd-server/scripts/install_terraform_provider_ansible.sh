#!/bin/bash

# What version and platform
export TPA_VERSION="v0.0.4"
export TPA_PLATFORM="linux_amd64"

# Create and enter terraform plugin dir
mkdir -p ~/.terraform.d/plugins
cd ~/.terraform.d/plugins

# Download and unzip in correct directory
curl -sSL -o ./terraform-provider-ansible-$TPA_PLATFORM.zip https://github.com/nbering/terraform-provider-ansible/releases/download/$TPA_VERSION/terraform-provider-ansible-$TPA_PLATFORM.zip
unzip -d . ./terraform-provider-ansible-$TPA_PLATFORM.zip

# Remove zip file
rm terraform-provider-ansible-$TPA_PLATFORM.zip
