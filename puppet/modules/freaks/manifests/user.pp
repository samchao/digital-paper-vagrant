class freaks::user (
    $group = 'deploy',
    $user = 'deploy',
    $home = '/home/deploy'
  ) {
  group { $group:
    ensure => present,
  }->
  user { $user:
    ensure   => present,
    gid      => $group,
    shell    => '/bin/bash',
    home     => $home,
    comment  => 'deploy user'
  }->
  file { [$home,
          "$home/.ssh"]:
    ensure => 'directory',
    owner  => $user,
    group  => $group
  }->
  file { "$home/.ssh/authorized_keys":
    content  => "$::authorized_keys",
    mode    => '600',
    owner   => $user,
    group   => $group,
  }
}
