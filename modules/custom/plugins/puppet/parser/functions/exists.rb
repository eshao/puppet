module Puppet::Parser::Functions
  newfunction(:exists, :type => :rvalue) do |arg|
    File.exists?(arg[0]) || File.symlink?(arg[0])
  end
end
