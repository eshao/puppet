# environment/ruby/thin.pp
#
# Doesn't start anything running by itself, but provides easy potential to.
#
# To remove this, need to delete from nodes.pp AND manually rm the service file.

class environment::ruby::thin inherits environment::ruby {
  package { "thin":
    provider => "gem",
    require  => Package["rubygems"],
  }

  # Generate the configuration. 
  #   ref: <http://www.sinatrarb.com/book.html#deployment>
  define thin_cluster_config($chdir,
                             $address              = '127.0.0.1',
                             $port,
                             $log                  = 'log/thin.log',
                             $environment          = 'development',
                             $user                 = 'www',
                             $group                = 'www',
                             $pid                  = 'log/thin.pid',
                             $max_conns            = 1024,
                             $max_persistent_conns = 512,
                             $timeout              = 30,
                             $servers              = 1,
                             $daemonize            = true) {

    file { "$chdir/log/thin.yml": content => "
---
chdir: $chdir
address: $address
port: $port
log: $log
environment: $environment
user: $user
group: $group
pid: $pid
max_conns: $max_conns
max_persistent_conns: $max_persistent_conns
timeout: $timeout
rackup: log/rackup.ru
servers: $servers
daemonize: $daemonize" 
    }
    file { "$chdir/log/rackup.ru": content => "
require 'application.rb'
run Sinatra::Application" 
    }
    file {"/usr/local/etc/rc.d/thin_$name":
      mode    => 555,
      content => template("environment/thin.erb"),
    }
  
    # The mongrel package/service.
    # Note: mongrel_cluster can NOT determine status well by itself.
    service { "thin_$name":
      hasstatus => false,
      pattern   => "thin server",
      require   => File["$chdir/log/rackup.ru"],
    }
  }
}

