# project/alhowar/sinatra.pp

class project::alhowar::sinatra inherits environment::ruby::sinatra {
  $alhowar_owner     = 'www'
  $alhowar_group     = 'howar'  # 46927
  $alhowar_directory = "/var/www/alhowar.com/thin/"

  thin_cluster_config { "alhowar":
    chdir => $alhowar_directory,
    port  => 6927,
    group => $alhowar_group,
  }
}
