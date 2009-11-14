# environment/ruby/mongrel.pp
#
# Doesn't start anything running by itself, but provides easy potential to.

class environment::ruby::mongrel inherits environment::ruby {
  $mongrel_prefix = "/usr/local/etc/mongrel_cluster"

  # Make sure configuration directory exists.
  file { $mongrel_prefix:
    ensure  => directory,
    require => Package["rubygem-mongrel_cluster"],
  }
  # Actually generate the configuration. 
  define mongrel_cluster_config($user        = 'mongrel',
                                $cwd,
                                $port,
                                $log_file    = 'log/mongrel.log',
                                $environment = 'development',
                                $user        = 'www',
                                $group       = 'www',
                                $address     = '127.0.0.1',
                                $pid_file    = 'log/mongrel.pid',
                                $servers     = 2) {
    $content = "
---
cwd: $cwd
log_file: $log_file
port: '$port'
environment: $environment
user: $user
group: $group
address: $address
pid_file: $pid_file
servers: $servers
"
    file { "$mongrel_prefix/$name.yml":
      content => $content,
    }
  }
  
  # The mongrel package/service.
  # Note: mongrel_cluster can NOT determine status well by itself.
  package { ["rubygem-mongrel", "rubygem-mongrel_cluster"]: 
    require  => Package["rubygems"] 
  }
  service { "mongrel_cluster": 
    enable    => false,
    hasstatus => false,
    pattern   => "/usr/local/bin/mongrel_rails",
    require   => File[$mongrel_prefix],
  }
}

