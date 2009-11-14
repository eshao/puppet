# macros.pp
#
# Defines new resource types as a poor man's macro.

# Synchronize a static file with the server.
# Note: notify is inherited from parent, so no need to explicitly specify.
define sync($prefix, $module,
            $owner  = $root, 
            $group  = $wheel, 
            $mode   = 664,
            $ensure = present) {
  # Doesn't actually work because run on client instead of host.
#  if puppet_exists("$name.$hostname.erb") {
#    $exists = true
#  } else {
#    if puppet_exists("$name.$operatingsystem") {
#      $exists = true
#    } else {
#      if puppet_exists("$name") {
#        $exists = true
#      } else {
#        $exists = false
#      }
#    }
#  }

  file { "$prefix/$name":
    alias  => $name,
    source => [
      "puppet:///$module/$name.$hostname",
      "puppet:///$module/$name.$operatingsystem",
      "puppet:///$module/$name",
#      "puppet:///custom/blank", messes up sshd.
    ],
  }
 
  # Set overrides here so that defaults from File still work.
  if $mode != 664       { File["$prefix/$name"] { mode   => $mode } }
  if $owner != $root    { File["$prefix/$name"] { owner  => $owner } }
  if $group != $wheel   { File["$prefix/$name"] { group  => $group } }
  if $ensure != present { File["$prefix/$name"] { ensure => $ensure } }
}

# Synchronize a static directory with the server.
define sdir($prefix, $module,
            $owner  = $root, 
            $group  = $wheel, 
            $mode   = 664,
            $links  = manage,
            $ignore = '',
            $ensure = present) {
  file { "$prefix/$name":
    links   => $links,
    ignore  => $ignore,
    recurse => inf,
    purge   => true,
    source  => [
      "puppet:///$module/$name.$hostname",
      "puppet:///$module/$name.$operatingsystem",
      "puppet:///$module/$name",
    ],
  }

# Doesn't work because ensure => directory nukes symlinks.
#  if defined(File["$prefix"]) {
#  } else {
#    if exists("$prefix") {
#      file { "$prefix": 
#        owner  => undef,
#        group  => undef,
#        mode   => undef,
#        ensure => present,
#      }
#    } else {
#      file { "$prefix": 
#        owner  => $owner,
#        group  => $group,
#        mode   => $mode,
#        ensure => directory,
#      }
#    }
#  }

  # Set overrides here so that defaults from File still work.
  if $mode != 664       { File["$prefix/$name"] { mode   => $mode } }
  if $owner != $root    { File["$prefix/$name"] { owner  => $owner } }
  if $group != $wheel   { File["$prefix/$name"] { group  => $group } }
  if $ensure != present { File["$prefix/$name"] { ensure => $ensure } }
}

# Synchronize a dynamic (template) file with the server.
define itpl($prefix, $module,
            $owner  = $root, 
            $group  = $wheel, 
            $mode   = 664, 
            $ensure = present) {
  if puppet_exists("$name.$hostname.erb") {
    $template = template("$module/$name.$hostname.erb")
  } else { 
    if puppet_exists("$name.$operatingsystem.erb") {
      $template = template("$module/$name.$operatingsystem.erb")
    } else {
      $template = template("$module/$name.erb")
    }
  }

  file { "$prefix/$name":
    alias   => $name,
    content => $template,
  }

  # Set overrides here so that defaults from File still work.
  if $mode != 664       { File["$prefix/$name"] { mode   => $mode } }
  if $owner != $root    { File["$prefix/$name"] { owner  => $owner } }
  if $group != $wheel   { File["$prefix/$name"] { group  => $group } }
  if $ensure != present { File["$prefix/$name"] { ensure => $ensure } }
}

