# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = 'ubuntu/trusty64'
  config.ssh.forward_agent = true

  config.vm.provider :digital_ocean do |digital, override|
    override.vm.box = 'digital_ocean'
    override.ssh.private_key_path = "~/.ssh/id_rsa"

    digital.token                = ENV['DIGITAL_OCEAN_TOKEN']
    digital.ssh_key_name         = ENV['DIGITAL_SSH_KEY_NAME']
    digital.image                = "Ubuntu 14.04 x64"
    digital.region               = "ams3"
    digital.size                 = "512MB"
    digital.private_networking   = "true"
    digital.domain               = 'agilefreaks.com'
  end

  config.trigger.after [ :up, :resume, :provision ], :stdout => true, :vm => /^((?!mongo).)*$/ do
    info 'Update infrastructure'
    # Put your custom scripts stored in ./scripts here
  end

  config.trigger.before [ :destroy, :suspend, :halt ], :stdout => true, :vm => /^lb/ do
    info 'Update infrastructure'
    # Put your custom scripts stored in ./scripts here
  end

  define_machine = ->(name) { config.vm.define(name) { |machine| machine.vm.hostname = name } }

  2.times { |i| define_machine.call("lb0#{i + 1}") }

  2.times { |i| define_machine.call("rubystagingexample0#{i + 1}") }

  2.times { |i| define_machine.call("rubyproductionexample0#{i + 1}") }

  2.times { |i| define_machine.call("mongo0#{i + 1}") }
  
  config.vm.define 'admin' do |machine|
    machine.vm.hostname = 'admin'
  end

  config.vm.provision :shell, path: "scripts/puppet.sh" 

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.manifest_file  = 'site.pp'
    puppet.options = '--verbose'
    puppet.facter = { newrelic_license_key: ENV['NEWRELIC_LICENSE_KEY'], rvm_version: '1.26.3', ruby_version: '2.1.5', authorized_keys: '' }
  end
end
