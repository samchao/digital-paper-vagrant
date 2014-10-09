class freaks::nginx::websecure (
    $app_name = 'freaks',
    $deploy_to = '/var/www'
  ) {
  class { 'freaks::nginx::base':
    app_name => $app_name,
    deploy_to => $deploy_to
  }->
	nginx::resource::vhost { "${hostname}":
	  ensure => present,
	  proxy => "http://$app_name/",
	  access_log => "$deploy_to/$app_name/shared/log/nginx_access.log",
	  error_log => "$deploy_to/$app_name/shared/log/nginx_error.log",
	  ssl_cert => '/vagrant/certs/ssl-bundle.crt',
	  ssl_key => '/vagrant/certs/server.key',
	  rewrite_to_https => true,
	  ssl => true
	}
}
