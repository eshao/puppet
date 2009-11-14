# project/alhowar/rails.pp
#
# In Common Lisp:
#   ref: <http://homepage.mac.com/svc/LispMovies/index.html>
#
# In Rails:
#   ref: <http://ideasonrails.blogspot.com/2006/06/rewriting-reddit-in-rails-in-less-than.html>

class project::alhowar::rails inherits environment::ruby::rails {
  $alhowar_owner     = 'www'
  $alhowar_group     = 'howar'  # 46927
  $alhowar_directory = "/var/www/alhowar.com/rails/"

  Service["mongrel_cluster"] { enable  => true }
  mongrel_cluster_config { "alhowar":
    cwd   => $alhowar_directory,
    port  => 46927,
    group => $alhowar_group,
  }
}
