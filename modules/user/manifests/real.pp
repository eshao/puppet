# module: user/real.pp
#
# Concrete users that need to be on ALL servers.

class user::real inherits user::virtual {
  $default_users = [
    "eshao",
  ]

  realize Dgroup[$default_users]
  realize Duser[$default_users]
}
