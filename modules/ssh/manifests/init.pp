# module: ssh/init.pp
#
# -- Depends
# $root, $wheel, $ip

class ssh {
  # Files.
  $ssh_sync = [
    "ssh_host_dsa_key", 
    "ssh_host_key", 
    "ssh_host_rsa_key"
  ]
  $ssh_itpl = [
    "sshd_config",
  ]

  # Static sync.
  sync { $ssh_sync:
    prefix => "/etc/ssh",
    module => "ssh",
    mode => 600,
  }

  # Dynamic sync.
  itpl { $ssh_itpl:
    prefix => "/etc/ssh",
    module => "ssh",
    notify => Service[sshd],
  }

  # sshd service.
  service { sshd: 
    ensure  => true,
    enable  => true,
    require => File["sshd_config"],
  }
}

