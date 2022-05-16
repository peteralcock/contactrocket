# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # config.vm.provider :aws do |aws, override|
  #   config.vm.box = "dummy"
  #   config.vm.synced_folder ".", "/vagrant", disabled: true
  #   aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  #   aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  #   aws.region = 'us-east-1'
  #   aws.keypair_name = 'box'
  #   aws.region_config "us-east-1", :ami => "ami-zzzzz"
  #   aws.instance_type = 'm4.large'
  #   aws.elastic_ip = '127.0.0.1'
  #   aws.subnet_id = 'subnet-xxxxxx'
  #   aws.security_groups = ['sg-xxxx', 'sg-zzzzzc']
  #   aws.ami = 'ami-xxxx'
  #   aws.ssh_host_attribute = :public_ip_address
  #   override.ssh.pty = true
  #   override.ssh.username = 'ubuntu'
  #   override.ssh.private_key_path = '/Users/machine/.ssh/box.pem'
  # end
  #
  # config.vm.provider :digital_ocean do |provider, override|
  #   override.ssh.private_key_path = '~/.ssh/id_rsa'
  #   override.vm.box = 'digital_ocean'
  #   override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
  #   provider.token =  ENV['DIGITALOCEAN_TOKEN']
  #   provider.image = 'ubuntu-14-04-x64'
  #   provider.region = 'nyc3'
  #   provider.size = '2gb'
  # end
  #
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.88.10"
  config.vm.hostname = "app.local"
  config.vm.network "public_network"
    config.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "4096"
      vb.cpus = "2"
    end

  $script = <<SCRIPT

#!/bin/bash -ex
export RAILS_ENV=production
export RACK_ENV=production
exit 0
SCRIPT

  config.vm.provision "shell", inline: $script
  config.vm.provision "ansible" do |ansible|
    ansible.verbose = true
    ansible.playbook = 'site.yml'
    ansible.inventory_path = "./hosts"
    ansible.limit = 'local'
   # ansible.limit = 'digitalocean'
   # ansible.limit = 'aws'
  end

end

