# module: thttpd/init.pp

class thttpd {
  sync {"thttpd.conf":
    prefix  => "/usr/local/etc",
    module  => "thttpd",
    notify  => Service[thttpd],
    require => Package[thttpd],
  }

  # The thttpd service.
  package { "thttpd": }
  service { "thttpd": require => Package[thttpd] }
}
