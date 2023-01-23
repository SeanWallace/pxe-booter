#!/usr/bin/env bash

set -e

ssh-import-id-gh SeanWallace

apt-get update

# Install the DHCP server.
if ! systemctl is-active isc-dhcp-server; then
  apt-get install -y isc-dhcp-server
  ln -s /etc/apparmor.d/usr.sbin.dhcpd /etc/apparmor.d/disable/
  apparmor_parser -R /etc/apparmor.d/disable/usr.sbin.dhcpd
  sed -i 's/INTERFACESv4=""/INTERFACESv4="enp0s8"/g' /etc/default/isc-dhcp-server
  rm -f /etc/dhcp/dhcpd.conf
  ln -s /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf
  systemctl enable isc-dhcp-server
  systemctl start isc-dhcp-server
fi

# Install Docker.
if ! command -v docker || ! command -v docker; then
  apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  # Add Docker’s official GPG key.
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  # Set up the repository.
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker.
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
fi

# Get Glass running.
if ! pm2 show Glass; then
  # Install NodeJS and NPM.
  apt install -y nodejs npm

  # Install PM2.
  npm install pm2 -g

  # Download and setup Glass.
  cd /opt
  git clone https://github.com/Akkadius/glass-isc-dhcp.git
  cd glass-isc-dhcp
  mkdir logs
  chmod u+x ./bin/ -R
  chmod u+x *.sh
  npm install
  pm2 --name Glass start npm -- start

  # Make it run on startup.
  pm2 startup
  pm2 save
fi


# Create the netbootxyz directories.
mkdir -p /opt/netbootxyz/config
mkdir -p /opt/netbootxyz/assets
ln -fs /vagrant/docker-compose.netbootxyz.yml /opt/netbootxyz/docker-compose.netbootxyz.yml
ln -fs /vagrant/netbootxyz/assets/harvester /opt/netbootxyz/assets/harvester
ln -fs /vagrant/netbootxyz/config/harvester.ipxe /opt/netbootxyz/config/menus/harvester.ipxe

# Start netbootxyz.
docker-compose -f /opt/netbootxyz/docker-compose.netbootxyz.yml up -d