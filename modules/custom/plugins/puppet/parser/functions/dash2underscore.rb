module Puppet::Parser::Functions
  newfunction(:dash2underscore, :type => :rvalue) do |arg|
    arg[0].gsub('-', '_')
  end
end
