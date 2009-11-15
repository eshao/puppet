# module: user/lp.pp

class user::real::lp inherits user::real {
  $lp_users = [
    "eshao",
  ]
  $lp_group = "howar"
  dgroup { $lp_group: }  # Quickly instantiate group.

  # Add people to additional groups to grant permissions.
  Duser["eshao"] { groups +> ["www"] }

  # Override group for $lp_users and instantiate them.
  Duser[$lp_users] { gid => $lp_group }
  realize Duser[$lp_users]
}
