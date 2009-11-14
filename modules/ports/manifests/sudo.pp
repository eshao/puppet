# ports/sudo.pp

class ports::sudo { 
  package { 'sudo': ensure => present, provider => freebsd }
  sync { "sudoers":
    prefix  => $operatingsystem ? {
      freebsd => "/usr/local/etc",
      default => "/etc"
    },
    module => "ports",
    require => Package["sudo"],
    mode => 440,
  }
}
