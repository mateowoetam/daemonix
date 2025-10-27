#!/bin/bash

systemctl enable podman.socket
systemctl enable docker.service
systemctl enable nix-daemon.service
