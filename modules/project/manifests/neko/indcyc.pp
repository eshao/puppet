# project/neko/indcyc.pp

class project::neko::indcyc inherits environment::ruby::sinatra {
  $neko_owner     = 'www'
  $neko_group     = 'www'
  $neko_directory = "/var/www/indcyc.com/sinatra/"

  thin_cluster_config { "indcyc":
    chdir => $neko_directory,
    port  => 4632,
    group => $neko_group,
  }
}
