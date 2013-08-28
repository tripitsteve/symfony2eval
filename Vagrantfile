# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8000, host: 8001

  config.vm.network :private_network, ip: "192.168.38.86"
  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "vagrant_resources/cookbooks"

    # os stuff
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "git"
    chef.add_recipe "vim"

    # server stuff
    chef.add_recipe "ohai"
    chef.add_recipe "nginx"

    # other stuff
    chef.add_recipe "mysql"
    #chef.add_recipe "php"

  end
  config.vm.provision :shell, :path => 'vagrant_resources/bootstrap.sh'
end
