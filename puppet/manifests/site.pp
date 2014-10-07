package { "vim":
  ensure => latest
}

package { "git":
  ensure => latest
}

node /rubystagingexample\d./ {
  class { 'freaks::web':
    gemset => 'staging',
    app_name => 'staging'
  }
}

node /rubyproductionexample\d./ {
  class { 'freaks::web':
    gemset => 'production',
    app_name => 'production'
  }
}

node /^mongo\d.$/ {
  class { 'freaks::mongo': }
}

node /lb\d./ {
  class { 'freaks::haproxy': }
}

node 'admin' {
  class { 'freaks::admin': }
}
