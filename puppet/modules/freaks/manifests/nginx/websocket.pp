class freaks::nginx::websocket (
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
    proxy => "http://$app_name/",
    location_cfg_append => {
      'proxy_set_header Upgrade' => '$http_upgrade',
      'proxy_set_header Connection' => "upgrade",
    }
  }
}
