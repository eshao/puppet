require 'facter'

Facter.add("jailed") do
  setcode do
    `sysctl security.jail.jailed | sed "s/security.jail.jailed: //"`.strip
  end
end
