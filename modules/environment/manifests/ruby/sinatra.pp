# environment/ruby/sinatra.pp

class environment::ruby::sinatra inherits environment::ruby::thin {
  package { 
    "sinatra":
      provider => "gem",
      require  => Package["rubygems"];
  }
}
