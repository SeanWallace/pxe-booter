Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "pxe-booter"

   config.vm.provider "virtualbox" do |v|
       v.gui = false
       v.memory = 1024
       v.cpus = 2
  end

  config.vm.network "public_network", ip: "192.168.1.69/24", bridge: "en0: Ethernet"

  config.vm.provision :shell, path: "vm_bootstrap.sh"
end