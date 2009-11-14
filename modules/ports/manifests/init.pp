# module: ports/init.pp

class ports {
  define pkg_add() {
    package { '$name': 
      ensure => present, 
      provider => freebsd, 
    }
  }
}

