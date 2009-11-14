# module: ezjail/init.pp
#
# Several targets possible:
# 1) Top-level unjailed vmachine.
# 2) Second-level jailed vmachine: can create child jails under themselves.

# The purpose of this class is to ensure the host has enough flavour to create
# a child jail that can use puppetd --test.
#
# Target: Any (v)machine that will be creating child jails.
class ezjail {
  $ezjail_prefix = "/usr/local/etc"
  $ezjail_J      = "/usr/jails"
  $ezjail_JF     = "$ezjail_J/flavours"
  $ezjail_JFF    = "$ezjail_J/flavours/flavour"
  Itpl { prefix => $ezjail_prefix, module => "ezjail" }
  Sdir { prefix => $ezjail_JF, module => "ezjail" }
  File { require => Package[ezjail] }

  # Static sync.
  itpl { "ezjail.conf": }
  sdir { "flavour": ignore => '.git' } 
  # Copied from core.
  file { "$ezjail_JFF/etc/resolv.conf": source => "/etc/resolv.conf" }
  file { "$ezjail_JFF/etc/hosts": source => "/etc/hosts" }

  # Create per-jail fstab.
  define mount() {
    $fname = dash2underscore("fstab.$name")
    # Manage necessary files and fstab. 
    file {[
      "/usr/jails/$name/usr/home/eshao/.git",
      "/usr/jails/$name/usr/home/eshao/wsp"]: 
        ensure  => directory,
        owner   => 'eshao',
        group   => undef,
        mode    => undef;
      "/etc/$fname":
        content => template("ezjail/fstab.$hostname.erb");
    }
  }

  # The ezjail package.
  package { "ezjail": }
}

# When is_jailed = 0.
class ezjail::top inherits ezjail {
}

# Turtles all the way down... (is_jailed = 1)
class ezjail::middle inherits ezjail {
  # Ensure /basejail and /newjail are symlinked.
}
