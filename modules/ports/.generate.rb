#!/usr/bin/env ruby

`rm manifests/*`
init = <<-eos
# module: ports/init.pp

class ports {
  define pkg_add() {
    package { '\\$name': 
      ensure => present, 
      provider => freebsd, 
    }
  }
}
eos
`echo "#{init}" > manifests/init.pp`

# To generate a module with config files.
def generate(name, *config_files)
  tbr = <<-eos
class ports::#{name} { 
  package { '#{name}': ensure => present, provider => freebsd }
  eos

  config_files.each do |tuple|
    # One or two arguments?
    if tuple[1].nil? then
      file = tuple
    else
      file = tuple[0]
      mode = "mode => #{tuple[1]},"
    end
    tbr << <<-eos
  sync { "#{file}":
    prefix  => $operatingsystem ? {
      freebsd => "/usr/local/etc",
      default => "/etc"
    },
    module => "ports",
    require => Package["#{name}"],
    #{mode}
  }
  eos
  end

  tbr << "}"
  File.open("manifests/#{name}.pp", 'w') {|f| f.write(tbr) }
  puts "Generated manifests/#{name}.pp"
end
