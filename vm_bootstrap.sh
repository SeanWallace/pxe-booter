#!/usr/bin/env bash

set -e

apt-get update

# Install the DHCP server.
apt-get install -y isc-dhcp-server

# Install Docker prerequisites.
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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


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


# Start netbootxyz.
docker run -d \
  --name=netbootxyz \
  -p 3001:3000  `# sets webapp port` \
  #   -p 69:69/udp #          `# sets tftp port`   -p 80:80                         `# optional`   -v
  #   /netbootxyz/config:/config   `# optional`   -v /netbootxyz/assets:/assets   `# optional`   --restart unless-stopped   ghcr.io/netbootxyz/netbootxyz