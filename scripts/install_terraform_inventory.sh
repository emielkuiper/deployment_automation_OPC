#!/bin/bash

# What version
export TIA_VERSION="v1.0.1"

# Create and enter terraform plugin dir
mkdir inventory
cd inventory

# Download and unzip in correct directory
curl -sSL -o ./terraform.py https://github.com/nbering/terraform-inventory/releases/download/$TIA_VERSION/terraform.py
