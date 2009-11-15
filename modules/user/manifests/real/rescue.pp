# module: user/rescue.pp

class user::real::rescue inherits user::real {
  $groups = ["neko", "dso"]

  dgroup {$groups: }
  Duser["eshao"] { groups +> $groups }
}
