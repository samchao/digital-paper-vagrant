class freaks::nginx::base (
    $app_name = 'freaks',
    $deploy_to = '/var/www',
    $user = 'deploy',
    $group = 'www-data'
  ) {
  file { [$deploy_to,
        "$deploy_to/$app_name",
        "$deploy_to/$app_name/releases",
        "$deploy_to/$app_name/shared",
        "$deploy_to/$app_name/shared/log",
        "$deploy_to/$app_name/shared/tmp",
        "$deploy_to/$app_name/shared/tmp/sockets",
        "$deploy_to/$app_name/shared/tmp/pids"]:
    ensure => 'directory',
    owner  => $user,
    group  => $group
  }->

  class { 'nginx': }

  nginx::resource::upstream { "$app_name":
    ensure  => present,
    members => ["unix:$deploy_to/$app_name/shared/tmp/sockets/puma.sock"]
  }
}
