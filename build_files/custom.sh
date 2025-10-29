#!/bin/bash

# custom name
sed -i 's/^NAME=.*/NAME="Fedora (Daemonix)"/' /etc/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="Fedora (Daemonix)"/' /etc/os-release
