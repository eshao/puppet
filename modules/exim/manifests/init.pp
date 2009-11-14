# module: exim/init.pp
#
# It should set itself up, but try these troubleshooting steps:
#   ref: <http://wiki.exim.org/TroubleShooting>
#
# Steps after configuration to get through anti-spam:
# 1) Configure reverse DNS.
# 2) Configure SPF.

class exim {
  Itpl { module => "exim" }
  File { notify => Service[exim], require => Package[exim] }

  # Dynamic sync.
  itpl {"mailer.conf": prefix => "/etc/mail" }
  itpl {"configure":
    prefix  => "/usr/local/etc/exim",
    mode    => 644,
  }

  # /etc/aliases
  itpl { "aliases":
    prefix => "/etc/mail",
    mode   => 644,
  }
  exec { "newaliases": 
    subscribe   => Itpl["aliases"], 
    refreshonly => true,
  }
  file { "/etc/aliases": ensure => "mail/aliases" }

  # Don't `mailq -Ac` during nightly runs.
  # ref: <http://exim.org/exim-html-4.30/doc/html/FAQ_21.html>
  core::freebsd::periodic_conf { 
    "daily_status_include_submit_mailq": value => "NO";
  }

  # The exim service.
  package {"exim": }
  service {"exim": require => Itpl[configure] }
}

class exim::sendonly inherits exim {
  Service["exim"] { 
    hasstatus => false,  # Will just report error message of not having rc val.
    ensure    => stopped,
  }
}
