# module: puppet/init.pp

class puppet {
  # Per-module defaults.
  $puppet_prefix = $operatingsystem ? {
    freebsd => "/usr/local/etc/puppet",
    default => "/etc/puppet",
  }
  Sync { prefix => $puppet_prefix, module => "puppet" }
  Itpl { prefix => $puppet_prefix, module => "puppet" }
  File { require => Package[puppet], notify => Service[puppetd] }

  # Sync.
  $puppet_sync = [
    "autosign.conf", 
    "namespaceauth.conf", 
  ]
  $puppet_itpl = [
    "puppet.conf", 
    "tagmail.conf",
  ]
  sync { $puppet_sync: mode => 644 }
  itpl { $puppet_itpl: mode => 644 }

  # Ensure that /etc/puppet -> /usr/local/etc/puppet on FreeBSD.
  file { "/etc/puppet": 
    ensure => $operatingsystem ? {
      freebsd => "/usr/local/etc/puppet",
      default => directory,
    },
  }

  # The puppetd service.
  package { "puppet": }
  service { "puppetd": require => File["puppet.conf"] }
}

class puppet::master inherits puppet {
  Sync[$puppet_sync] { notify +> Service[puppetmasterd] }
  Itpl[$puppet_itpl] { notify +> Service[puppetmasterd] }
  service { "puppetmasterd": require => File["puppet.conf"] }
}
