# module: nginx/fastcgi.pp

class nginx::fastcgi {
  # Use latest recommended configuration.
  file {"/usr/local/etc/php.ini": 
    alias  => "php.ini",
    ensure => "/usr/local/etc/php.ini-recommended",
  }

  # The fastcgi-php service.
  package {["php5", "spawn-fcgi"]: require => Package[nginx] }
  package {["php5-extensions", "php5-mysql"]: require => Package[php5] }
  core::freebsd::ports_enable {"spawn_fcgi": }

  # The service can check its own pid correctly, but only if no syntax errors,
  # which are prone because of the messed up spawn-fcgi rc.conf.d file.
  service { "spawn-fcgi": require => Package[spawn-fcgi] }
}

