#!/usr/bin/env bash

VERSION="v1.1.1"

wget https://releases.rancher.com/harvester/$VERSION/harvester-$VERSION-amd64.iso
wget https://releases.rancher.com/harvester/$VERSION/harvester-$VERSION-initrd-amd64
wget https://releases.rancher.com/harvester/$VERSION/harvester-$VERSION-vmlinuz-amd64
wget https://releases.rancher.com/harvester/$VERSION/harvester-$VERSION-rootfs-amd64.squashfs
wget https://releases.rancher.com/harvester/$VERSION/harvester-$VERSION-amd64.sha512
wget https://releases.rancher.com/harvester/$VERSION/version.yaml