# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = 'ubuntu/trusty64'

  config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa' ]
  config.ssh.forward_agent = true

  config.vm.synced_folder 'Digital-Paper/', '/home/vagrant/Digital-Paper'

  config.vm.define 'web' do |web|
    web.vm.box = "ubuntu/trusty64"
    web.vm.hostname = "web"
    web.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end
  end

  config.vm.network "public_network"
  config.vm.network :forwarded_port, host: 3000, guest: 3000

  config.vm.provision :shell, path: 'scripts/puppet.sh'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.manifest_file  = 'site.pp'
    puppet.options = '--verbose'
    puppet.facter = { 
      rvm_version: '1.26.9',
      ruby_version: '2.1.5',
      repo_path: '' 
    }
  end
end
