# module: mysql/init.pp
#
# 1. Install mysql50-{server,client} manually, as ports are buggy.
# 2. Create some system tables by running <mysql_install_db>.
#
# Do 3-4 ONLY if not dumping (aka starting from scratch.)
# Otherwise just do <mysql -uroot < all>.
# 3. Set password for root: <mysqladmin -u root password 'new-pw'>
# 4. Set password for root@host: <mysqladmin -u root -h 'host' password 'old-pw'>
#
# 5. Use <mysqldump --all-databases> or <esql dumpall> on remote host.
# 6. Use <mysql -uroot -p'pw' < [dump]> to restore all data.
# 7. Make sure to run <mysql_upgrade> as it will fix the grants table.

class mysql {
  # The mysql service -- version compatible with sphinxsearch.
  # We specify source because the name of the package is different from 
  # the name of used to query existence locally.
  #
  # Note: Usually this doesn't work and you have to install manually, 
  # but at least afterwards, no warning/error messages.
  package { "mysql-server": source => "mysql50-server" }
  package { "mysql-client": source => "mysql50-client" }
  service { "mysql-server": require => Package["mysql-server"] }
  core::freebsd::ports_enable { "mysql": } 
}

class mysql::sphinx {
  $sphinx_user  = "_sphinx"
  $sphinx_group = "_sphinx"

  package { "sphinxsearch": require => Package["mysql-client"] }
  service { "sphinxsearch": require => Package["sphinxsearch"] }
}

