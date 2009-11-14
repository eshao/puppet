# environment/ruby.pp

class environment::ruby {
  # An explaination of the difference between ports and gems can be found at:
  #   <ref: http://www.zytrax.com/tech/survival/freebsd-update.html#ruby>
  #
  # For some reason, everything breaks horribly without iconv.
  package { 
    "ruby":;
    "ruby18-iconv": 
      require  => Package["ruby"];
    "ruby18-gems":
      alias    => "rubygems", 
      require  => Package["ruby", "ruby18-iconv"];

    # SQLite is a good drop-in default database.
    # Need to install sqlite3-ruby gem manually.
    #   ref: <http://overtherailing.com/post/189122066/installing-the-sqlite3-ruby-gem-on-freebsd-7-2>
    "sqlite3":;
    "rubygem-sqlite3":;

    # Very common rubygems.
    "haml":
      provider => "gem",
      require  => Package["rubygems"];
  }
}
