class freaks::nginx::web (
    $app_name = 'freaks',
    $deploy_to = '/var/www'
  ) {
  class { 'freaks::nginx::base':
    app_name => $app_name,
    deploy_to => $deploy_to
  }->
  nginx::resource::vhost { "${app_name}":
    ensure => present,
    access_log => "$deploy_to/$app_name/shared/log/nginx_access.log",
    error_log => "$deploy_to/$app_name/shared/log/nginx_error.log",
    proxy => "http://$app_name/"    
  }
}
