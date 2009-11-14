# environment/ruby/rails.pp
#
# Default installation for rails + some projects with dependencies maintained
# through puppet.

class environment::ruby::rails inherits environment::ruby::mongrel {
  package { 
    "rails":
      provider => "gem",
      require  => Package["rubygems"];
  }
}
