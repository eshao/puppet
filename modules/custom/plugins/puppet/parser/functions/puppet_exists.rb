module Puppet::Parser::Functions
  newfunction(:puppet_exists, :type => :rvalue) do |arg|
    confdir = '/usr/local/etc/puppet'
    path    = File.join(confdir, "modules")
    return false if !File.exist?(path)

    !`find #{path} -name #{arg[0]}`.empty?
  end
end
