# project/alhowar/reddit.pp
#
# Process outlined on reddit trac.
#   ref: <http://code.reddit.com/wiki/RedditStartToFinishFreeBSD>
#
# 1) Run PMR to install packages.
# 2) Use ez_install to install Imaging.
# 3) Use git to grab reddit source code.
# 4) Follow instructions to run <reddit/r2/setup.py>.
# 5) Setup Postgre, create four initial databases.
# 6) Follow <http://www.reddit.com/r/redditdev/comments/8y0uj/can_i_serve_reddit_with_nginx/> to get nginx+reddit up.

class project::alhowar::reddit {
  package {
    "curl":;
    "freetype2":;
    "gcc":                  source => "gcc44";
    "gettext":;
    "git":;
    "jpeg":;
    "png":;
    "postgresql-server":    source => "postgresql82-server";
    "postgresql-libpqxx":;
    "postgresql-libpgeasy":;
    "subversion":;
    "python26":;
    "py26-setuptools":;
    "py26-psycopg2":;
  }
  service { 
    "postgresql":;
    "memcached":;
  }

  # Need authentication for ri to use database.
  #   err: sqlalchemy.exc.OperationalError: (OperationalError) 
  #     FATAL:  no pg_hba.conf entry for host "67.58.98.14",
  #             user "ri", database "newreddit", SSL off
  core::freebsd::line { "postgre_ri_auth":
    file => "/usr/local/pgsql/data/pg_hba.conf",
    line => "host all ri $ip/32 trust"
  }
}
