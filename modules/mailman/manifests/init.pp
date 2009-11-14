# module: mailman/init.pp
#
# README README README README README README README README README README
#
# -- INSTRUCTIONS:
# -- ref: <http://www.gnu.org/software/mailman/mailman-install/index.html>
#
#
# README README README README README README README README README README
# 
# For blank install:
# 1) Install exim, thttpd, nginx and configure them correctly.
# 2) Create site-wide mailing list by running <bin/newlist mailman>.
# 3) Run <bin/mmsitepass> to create a new password.
# 4) COPY (not link) files from <cgi-bin> to the www directory.
#    ref: <http://wiki.list.org/pages/viewpage.action?pageId=4030517>
#
# To move from one server to next:
#    ref: <http://www.debian-administration.org/article/Migrating_mailman_lists>
# 1) Do a blank install and make sure everything is working.
# 2) If anything is installed use <bin/rmlist -a> to remove them.
# 3) Run <bin/check_db -a> on the remote server AND after transfering.
# 4) Move <archives,data,lists> to the new server's mailman folder.
# 5) Run <bin/check_perms -f> to fix permissions after transferring.
# 6) Run <bin/update> to update data files.
# 7) [Optional] Run <bin/withlist -l -a -r fix_url -- -v> to fix URLs.
#    -l locks, -a all, -r run [script]
# Note: This will use the value in mm_cfg.py to determine desired new host.
# 8) Fix symlinks in <archives/public> if absolute location of mailman changed.
#
# For troubleshooting, check <logs/error>. Make sure it's world-writeable.

class mailman {
  # Some defaults.
  $mailman_prefix = $operatingsystem ? {
    freebsd => "/usr/local/mailman",
    ubuntu  => "/var/lib/mailman",
    default => "/var/lib/mailman",
  }
  $mailman_conf = $operatingsystem ? {
    freebsd => "$mailman_prefix/Mailman",
    ubuntu  => "/etc/mailman",
    default => "/etc/mailman",
  }
  $mailman_owner = "mailman"
  $mailman_group = "mailman"

  # Syncing files.
  itpl { "mm_cfg.py":
    prefix  => $mailman_conf,
    module  => "mailman",
    require => Package["mailman"],
    notify  => Service["mailman"],
  }

  # Run check-perms every day or so at 3a.
  cron { "mailman_check_perms":
    command => "$mailman_prefix/bin/check_perms -f > /tmp/mailman_check_perms",
    hour    => "3",
    minute  => "23",
  }

  # The mailman cgi-bin MUST be run with setuid or setgid, otherwise the 
  # webserver will not be able to edit/view the actual private files/packages.
  file { "/var/www/mailman":
    owner   => $mailman_owner,
    group   => $mailman_group,
    mode    => 2775,
    recurse => true,
  }

  # The mailman service.
  package { "mailman": require => Package["exim", "thttpd", "nginx"] }
  service { "mailman":  # The default mailman init script duplicates mailman.
    restart    => "$mailman_prefix/bin/mailmanctl restart",
    start      => "$mailman_prefix/bin/mailmanctl start",
    stop       => "$mailman_prefix/bin/mailmanctl stop",
    pattern    => "$mailman_prefix/bin/",
    hasstatus  => false,
    hasrestart => true,
  }
}
