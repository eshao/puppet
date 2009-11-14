# project/neko/annotalia.pp

class project::neko::annotalia inherits environment::ruby::sinatra {
  $neko_owner     = 'www'
  $neko_group     = 'www'
  $neko_directory = "/var/www/annotalia.com/sinatra/"

  thin_cluster_config { "annotalia":
    chdir => $neko_directory,
    port  => 2666,
    group => $neko_group,
  }
}
