# flatten.rb: flattens a one dimensional array into a string.

module Puppet::Parser::Functions
  newfunction(:flatten, :type => :rvalue) do |arg|
    "\"#{arg.join('", "')}\""
  end
end
