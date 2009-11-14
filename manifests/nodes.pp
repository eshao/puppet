# nodes.pp
#
# Defines specific node settings. Node names according to your puppet client 
# hostnames. A single host/node can inherit existing "zone/nodes" with the 
# possibility of overriding variables defined at more general levels. 

# All nodes not addressed directly.
node 'default' {
  include baseclass
}

# Rescue.
node 'rescue.nekogiri.com' inherits cpc {
  $ip  = "67.58.98.10"
  $lo  = "127.0.0.1"
  $noc = "edwin.shao@gmail.com"

  # Role
  include baseclass
  include ezjail

  # Mount jails
  ezjail::mount { ["hyper", "neko", "dso", "lp"]: }

  # Users
  include user::real::rescue
}

# Hypervisor.
node 'hyper.nekogiri.com' inherits cpc {
  $ip  = "67.58.98.11"
  $lo  = "127.0.0.11"
  $noc = "poleris@gmail.com"

  include baseclass, exim::sendonly
  include ezjail
  include puppet::master
}

# Neko.
node 'neko.nekogiri.com' inherits cpc {
  $ip  = "67.58.98.12"
  $lo  = "127.0.0.12"
  $noc = "edwin.shao@gmail.com"

  include baseclass, exim::sendonly
  include nginx, nginx::fastcgi, thttpd
  include mysql

  include project::neko::indcyc
  include project::neko::annotalia
  include user::real::neko
}

# DSO.
node 'dso.nekogiri.com' inherits cpc {
  $ip  = "67.58.98.13"
  $lo  = "127.0.0.13"
  $noc = "poleris@gmail.com"  # Change later.
  $mailman_lists = [
    "lists.dsoglobal.org",  # Used as default for mailman purposes.
    "lists.cmudso.org",
    "lists.nekogiri.com", 
  ]

  include baseclass, exim
  include mailman
  include nginx, nginx::fastcgi, thttpd
  include mysql, mysql::sphinx

  include project::dso::wishlist
  include user::real::dso
}

# LP.
node 'lp.nekogiri.com' inherits cpc { 
  $ip  = "67.58.98.14"
  $lo  = "127.0.0.14"
  $noc = "edwin.shao@gmail.com"

  include baseclass, exim::sendonly
  include nginx, nginx::fastcgi, thttpd

  include project::alhowar::rails
  include project::alhowar::sinatra
  include user::real::lp
}
