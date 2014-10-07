class freaks::nginx::web (
    $app_name = 'freaks',
    $deploy_to = '/var/www'
  ) {
  class { 'freaks::nginx::base':
    app_name => $app_name,
    deploy_to => $deploy_to
  }
}
