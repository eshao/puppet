# module: user/neko.pp

class user::real::neko inherits user::real {
  $neko_users = [
    "eshao",
    "example",
  ]

  Duser["eshao"] { groups +> $neko_users }

  # Override group for $neko_users and instantiate them.
  realize Dgroup[$neko_users]
  realize Duser[$neko_users]
}
