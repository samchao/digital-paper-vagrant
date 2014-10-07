class freaks::nginx::websocket (
    $app_name = 'freaks',
    $deploy_to = '/var/www'
  ) {
  class { 'freaks::nginx::base':
    app_name => $app_name,
    deploy_to => $deploy_to,
    cfg_append => {
      'proxy_set_header Upgrade' => '$http_upgrade',
      'proxy_set_header Connection' => "upgrade",
    }
  }
}
