# defaults.pp
#
# Some resource defaults.

Exec {
  path => [
    "/usr/libexec", 
    "/sbin", 
    "/bin",
    "/usr/sbin",
    "/usr/bin",
    "/usr/games",
    "/usr/local/sbin",
    "/usr/local/bin",
  ],
}

File {
  owner  => $root,
  group  => $wheel,
  mode   => 664,
  ensure => present,
}

Service {
  ensure    => running,
  enable    => true,
  hasstatus => true,
}

# For Freebsd, the default is to use ensure => latest, provider => ports
Package {
  ensure   => present,
  provider => freebsd,
}

Cron {
  ensure => present,
}

# Users and groups.
User {
  ensure    => present,
  allowdupe => false,
  shell     => $operatingsystem ? {
    freebsd => '/usr/local/bin/bash',
    default => '/bin/bash',
  },
}

Group {
  ensure => present,
}
