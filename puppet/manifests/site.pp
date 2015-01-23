package { "vim":
  ensure => latest
}

package { "git":
  ensure => latest
}

package { "nodejs": 
  ensure => latest
}

package { "libpq-dev": 
  ensure => latest
}

package { "default-jre": 
  ensure => latest
}

node /web/ {
  class { 'freaks::digital_paper':
    gemset => 'digital-paper',
    app_name => 'digital-paper'
  }
}
