# roles.pp
#
# Define the various roles used by the nodes. There is a general class with 
# general modules used in all the hosts and then some specific roles with 
# extra includes.

case $operatingsystem {
  freebsd: {
    $root  = "root"
    $wheel = "wheel"
  }
  default: {
    $root  = "root"  # root's login
    $wheel = "root"  # root's group
  }
}

class minimum {
  include core, puppet
  include ports, ports::sudo
}

class baseclass {
  include minimum, ssh
  include user::real  # Instantiate users that should be on ALL servers.
}

