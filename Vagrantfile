# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "westlife-eu/scientific_7_gui"
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
     vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "2048"
     vb.cpus = "2"
  end
  if Vagrant::VERSION =~ /^1.9.3/
    puts "vagrant version 1.9.3, fixing host_ip configuration "
    # forward standard web
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 80, host: 8080
  else
    if Vagrant::VERSION =~ /^1.9.4/
      puts "vagrant version 1.9.4 detected. Upgrade to version 1.9.5+ or downgrade to version 1.9.3 or bellow"
      exit
    else
      puts "vagrant version:"
      puts Vagrant::VERSION
      # forward standard web
      config.vm.network "forwarded_port", guest: 80, host: 8080
    end
  end  
  config.vm.provision "shell",  path: "scripts/bootstrapbin.sh"
  config.vm.synced_folder ".", "/vagrant"
end
