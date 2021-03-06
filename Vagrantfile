# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = "aws"

puts "Initializing user data files"
system "./bin/setup-user-data.sh"
if $? != 0
  abort "Failed to create user-data file"
end

if (ENV['AWS_ACCESS_KEY_ID'].empty? || ENV['AWS_SECRET_ACCESS_KEY'].empty?)
  abort("AWS_ACCESS_KEY_ID #{ENV['AWS_ACCESS_KEY_ID']} or AWS_SECRET_ACCESS_KEY #{ENV['AWS_SECRET_ACCESS_KEY']} are not defined")
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.40.20"
  # config.vm.box = "dummy"
  # config.vm.provider "aws" do |aws, override|
  #   aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  #   aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  #   aws.keypair_name = "otaeguis"

  #   aws.ami = "ami-018c9568" # trusty 64 PV
  #   #aws.instance_type = "m3.medium"
  #   aws.instance_type = "t1.micro"
  #   aws.region = "us-east-1"
  #   aws.security_groups = [ 'jenkins' ]
  #   aws.user_data = File.read("aws/cloud-init.mime")
  #   override.ssh.username = "ubuntu"
  #   override.ssh.private_key_path = "~/.ssh/id_rsa"
  #   aws.tags = {
  #     'Name' => 'id.spantree.net',
  #     'Hostname' => 'id',
  #     'fqdn' => 'id.spantree.net',
  #     'Role' => 'identity server',
  #   }
  #   aws.block_device_mapping = [
  #     {
  #       'DeviceName' => '/dev/sda1',
  #       'Ebs.VolumeSize' => 50
  #     }
  #   ]
  # end

  config.vm.synced_folder ".", "/usr/local/src/project", :create => "true"
  config.vm.synced_folder "puppet", "/usr/local/etc/puppet", :create => "true"

  config.vm.provision :shell, :path => "shell/os-detect-setup.sh"
  config.vm.provision :shell, :path => "shell/initial-setup.sh"
  config.vm.provision :shell, :path => "shell/update-puppet.sh"
  config.vm.provision :shell, :path => "shell/librarian-puppet-vagrant.sh", :args => "/vagrant/shell"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.options = [
      "--verbose",
      "--debug",
      "--ordering=manifest", 
      "--modulepath=/etc/puppet/modules:/usr/local/etc/puppet/modules",
      "--hiera_config /usr/local/src/project/hiera.yaml"
    ]
  end
end
