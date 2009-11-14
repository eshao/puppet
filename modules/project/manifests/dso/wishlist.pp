# project/dso/wishlist.pp
#
# dsoglobal.org's Wishlist.
# 1) First, don't panic! The steps to install are generally simple!
# 2) Make sure rubygems, rails, mysql, sphinx, etc. are all installed.
# 3) Configure mysql according to instructions on that class' page.
# 4) Import dump from previous Wishlist mysql.
# 5) Ensure the wishlist.yml file has correct syntax / user+group created.
# 6) Ensure mongrel has permissions and sphinx has permissions to pid.
# 7) Run rc mongrel_cluster start and check /log/mongrel*.log for errors.
#
# At this point, the homepage should show up, but no opportunities. So
# let's configure sphinx to index the opportunities.
# 8) Ensure sphinx is running using the configuration in <config
# 9) Run sudo -u _sphinx rake ts:index once and verify output. 
#    <ref: dist/wishlist_sphinx_ts:index.output>.
#
# Remember to reboot mongrel_cluster periodically throughout the install!
class project::dso::wishlist inherits environment::ruby::rails {
  $wishlist_owner     = 'www'
  $wishlist_group     = 'dso'
  $wishlist_directory = "/var/www/dsoglobal.org/wishlist/"

  Package { provider => "gem", require => Package["rubygems"] } 
  Package["rails"] { ensure +> "2.2.2" }
  package { 
    "mislav-will_paginate": ensure => "2.2.3";
    "mysql":                ensure => latest;
  }

  # Also requires sphinxsearch from class mysql::sphinx.
  # Note: this setup assumes it is the ONLY application using sphinx.
  Service["mongrel_cluster"] { 
    enable  => true,
    require +> Service["sphinxsearch"],
  }
  mongrel_cluster_config { "wishlist":
    cwd   => $wishlist_directory,
    port  => 9474,
    group => $wishlist_group,
  }

  # Make sure sphinx configuration linked correctly.
  file { 
    "/usr/local/etc/sphinx.conf": 
      target => "$wishlist_directory/config/development.sphinx.conf";
    "$wishlist_directory/log/searchd.development.pid":
      target => "/var/run/sphinxsearch/searchd.pid",
      owner   => $mysql::sphinx::sphinx_user,
      group   => $mysql::sphinx::sphinx_group,
      mode    => undef;
  }

  # Setup the cronjob for sphinx: will execute every 3 minutes!
  # Because stdout is being redirected, only emails on error.
  cron { "wishlist_hourly":
    command => "$wishlist_directory/cron/hourly > /tmp/wishlist_hourly",
    minute  => "*/3",
    user    => $root,
  }

  # Some permissions that have to be set correctly:
  # $wishlist_directory => www:dso
  file {[
    "$wishlist_directory/config/development.sphinx.conf",
    "$wishlist_directory/log/searchd.log",
    "$wishlist_directory/log/searchd.query.log",
    "$wishlist_directory/db",
    "/var/run/sphinxsearch"]: 
      owner   => $mysql::sphinx::sphinx_user,
      group   => $mysql::sphinx::sphinx_group,
      mode    => undef,
      recurse => true,
      require => File["$wishlist_directory"];
    "$wishlist_directory":
      owner   => $wishlist_owner,
      group   => $wishlist_group,
      mode    => undef,
      recurse => true;
    "$wishlist_directory/log/development.log": mode => 666;
  }
}
