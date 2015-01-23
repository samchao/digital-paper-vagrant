class freaks::web_base (
    $gemset = 'freaks',
    $app_name = 'freaks',
    $user = 'deploy'
  ) {
  class { 'freaks::user': }->
  class { 'freaks::ruby':
    gemset => $gemset,
    user => $user
  }
}

class freaks::digital_paper (
    $gemset = 'freaks',
    $app_name = 'freaks',
    $user = 'vagrant'  
  ) {
  class { 'freaks::web_base':
    gemset => $gemset,
    app_name => $app_name,
    user => $user
  }->
  class { 'postgresql::server': 
    postgres_password => 'postgres',
  }->
  vcsrepo { "/home/vagrant/Digital-Paper":
    ensure   => latest,
    provider => git,
    source   => $repo_path,
    revision => 'master',
    owner => $user
  }->
  exec { 'web: copy database.yml.sample database.yml':
    command => "cd Digital-Paper && /bin/bash --login -c 'sudo cp config/database.yml.sample config/database.yml'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: install gems':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle install'",
    provider => shell,
    user => $user,
    timeout => 2000,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: create database':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rake db:create'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: run migrations':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rake db:migrate'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: seed':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rake db:seed'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: seed users':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rake db:seed_users'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: stop solr if started':
    command => '/bin/true',
    unless => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rake sunspot:solr:stop'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: run solr':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rake sunspot:solr:start'",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }->
  exec { 'web: run':
    command => "cd Digital-Paper && /bin/bash --login -c 'rvm use $ruby_version@$gemset do bundle exec rails s' &",
    provider => shell,
    user => $user,
    environment => ["HOME=/home/$user"]
  }
}

class freaks::web (
    $gemset = 'freaks',
    $app_name = 'freaks'
  ) {
  class { 'freaks::web_base':
    gemset => $gemset,
    app_name => $app_name
  }->
  class { 'freaks::nginx::web':
    app_name => $app_name,
    deploy_to => $deploy_to,
  }
}

class freaks::websecure (
    $gemset = 'freaks',
    $app_name = 'freaks'
  ) {
  class { 'freaks::web_base':
    gemset => $gemset,
    app_name => $app_name
  }->
  class { 'freaks::nginx::websecure':
    app_name => $app_name,
    deploy_to => $deploy_to,
  }
}

class freaks::mongo {
  class { 'newrelic':
    license_key => $::newrelic_license_key,
    use_latest  => true
  }

  class { 'mongodb::globals':
    manage_package_repo => true,
  }->
  class { 'mongodb::server': 
    bind_ip => ['127.0.0.1',"$ipaddress_eth0"],
    replset    => 'rsfreaks'
  }->
  class { 'mongodb::client': }
}

class freaks::haproxy {
  class { 'apt': }
  apt::ppa { 'ppa:vbernat/haproxy-1.5': }->
  package { 'haproxy':
    ensure => latest
  }
}

class freaks::admin (
  $gemset = 'admin'
  ) {  
  class { 'newrelic':
    license_key => $::newrelic_license_key,
    use_latest  => true
  }
  
  class { 'rvm':
    version => $::rvm_version
  }->
  rvm_system_ruby { $::ruby_version:
    ensure      => present,
    default_use => true
  }->
  rvm_gemset { "$::ruby_version@$gemset":
    ensure  => present
  }->

  class { 'vagrant': }->
  vagrant::plugin { 'vagrant-digitalocean': }->
  vagrant::plugin { 'vagrant-triggers': }
}
