# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "pxe-booter"

   config.vm.provider "virtualbox" do |v|
       v.gui = false
       v.memory = 1024
       v.cpus = 2
  end

  config.vm.network "public_network", ip: "172.16.1.2", netmask:"255.255.0.0", bridge: "en6: AX88179A"

  # Bootstrap services.
  config.vm.provision :shell, path: "vm_bootstrap.sh"
end