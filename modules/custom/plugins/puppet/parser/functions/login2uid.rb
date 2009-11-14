module Puppet::Parser::Functions
  newfunction(:login2uid, :type => :rvalue) do |arg|
    minuid = 1100
    maxuid = 65530
    login  = arg[0]

    # Telephone transformation.
    uid = login.gsub(/[abc]/, '2')
    uid.gsub!(/[def]/, '3')
    uid.gsub!(/[ghi]/, '4')
    uid.gsub!(/[jkl]/, '5')
    uid.gsub!(/[mno]/, '6')
    uid.gsub!(/[pqrs]/, '7')
    uid.gsub!(/[tuv]/, '8')
    uid.gsub!(/[wxyz]/, '9')
    uid = uid.to_i

    # Boundary checking.
    uid = uid.modulo(maxuid)
    if uid < 1100 then
      return uid + 1100
    else
      return uid
    end
  end
end
