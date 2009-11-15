# module: user/dso.pp

class user::real::dso inherits user::real {
  $dso_users = [
    "eshao",
    "root_example",  # Superusers.
    "example",  # Regular users.
  ]
  $dso_group = "dso"
  dgroup { $dso_group: }  # Quickly instantiate group.

  # Give root to some users.
  Duser["root_example"] { groups +> ["wheel"] }

  # Override group for $dso_users and instantiate them.
  Duser[$dso_users] { gid => $dso_group }
  realize Duser[$dso_users]

  # Make sure users know where www is.
  define symlinks() { 
    file { 
      "/home/$name/dsoglobal.org": ensure => "/var/www/dsoglobal.org/public";
      "/home/$name/wishlist": ensure => "/var/www/dsoglobal.org/wishlist";
    }
  }
  symlinks { $dso_users: }
}
