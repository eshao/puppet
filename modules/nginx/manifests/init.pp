# module: nginx/init.pp

class nginx {
  # Define some defaults.
  $nginx_prefix = $operatingsystem ? {
    freebsd => "/usr/local/etc/nginx",
    default => "/etc/nginx",
  }
  $nginx_www = "/var/www"
  Sync { prefix => $nginx_prefix, module => "nginx", require => Package[nginx] }
  Sdir { prefix => $nginx_prefix, module => "nginx", require => Package[nginx] }
  Itpl { prefix => $nginx_prefix, module => "nginx", require => Package[nginx] }
  File { require => Package[nginx], notify => Service[nginx] }

  # Sync files.
  sync {[
    "mime.types",
    "fastcgi_params",
    "enabled/gen.host",
    "enabled/gen.all"]: 
  }
  sdir { "passwords": }
  itpl { "nginx.conf": }

  file {[
    # Create folders so puppet doesn't fail on fresh installs.
    "$nginx_www", 
    "$nginx_www/localhost", 
    "$nginx_www/localhost/log"]: 
      ensure => directory;
    "$nginx_prefix/enabled": 
      ensure => directory,
      mode => 770;

    # A quick symlink for compatability's sake.
    "/etc/nginx":
      ensure => $operatingsystem ? {
        freebsd => "/usr/local/etc/nginx",
        default => directory,
      };
  }

  # The nginx service.
  package { "nginx-devel": alias => "nginx" }
  service { "nginx": }
}

