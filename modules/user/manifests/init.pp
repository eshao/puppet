# module: users/init.pp
#
# Only has defaults. All actual users are virtualized in other class files.

class user {
  # Specify defaults for groups.
  #
  # IMPORTANT: Can't refer to $name in parameters: screws everything up for
  # some unknown reason.
  define dgroup($gid = '') {
    group { "$name": }
   
    Group[$name] { 
      gid => $gid ? {
        ''      => login2uid($name),
        default => $gid,
      }
    } 
  }

  # Specify (extensive) defaults for users.
  define duser($uid = '',
               $gid = '',
               $home = '',
               $groups = [],
               $password = false) {
    user { "$name": }
    @dgroup { "$name": }  # Create virtual resource by default, even if unused.

    # Manage home directory.
    if $home == '' {
      file { "/home/$name": 
        owner   => "$name",  # Can't ensure gid exists.
        group   => undef,
        mode    => undef,
        ensure  => directory,
        require => User[$name],
      }

      # Sync if <files/home.$name> exists.
      if puppet_exists("home.$name") {
        sdir { "home.$name": 
          owner   => "$name",  # Can't ensure gid exists.
          group   => undef,
          mode    => 700,
          prefix  => "/home/$name/.puppet",
          module  => "user",
          require => [User["$name"], File["/home/$name"]], 
        }
      }
      User[$name] { home => "/home/$name" }
    } else {  # User doesn't want us to manage their home.
      User[$name] { home => $home }
    }

    # Specify overrides here, so defaults don't get trampled on.
    # The below do not have sensible defaults, so force to standard.
    User[$name] {
      uid => $uid ? {
        ''      => login2uid($name),
        default => $uid,
      },
    }

    # Manage group.
    if $gid == '' {
      User[$name] {
        gid     => login2uid($name),
        require +> Group[$name],
      }
    } else {
      User[$name] { gid => $gid }
    }

    # FreeBSD has no password support.
    if $operatingsystem != 'FreeBSD' {
      if $password != false { User[$name] { password => $password } }
    } else {
    }

    # The below have sensible defaults, so only override if necessary.
    if $groups != [] { User[$name] { groups => $groups } }
  }
}
