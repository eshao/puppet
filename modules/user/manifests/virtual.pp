# module: user/virtual.pp
#
# Users should be declared virtually in a a class called user::virtual.
# These virtual users can then be realized as needed in user groups.
# (Note: The subclasses of users should mostly be logical groupings.)
#
# ref: <http://reductivelabs.com/trac/puppet/wiki/PuppetBestPractice>
# ref: <http://reductivelabs.com/trac/puppet/wiki/TypeReference#id313>

class user::virtual inherits user {
  # Manage users.
  @duser {
    # Me.
    "eshao":
      password => 'use_a_bogus_hash_here_...mSJVf5me/',
      groups   => ["wheel"];


    # Guests.
    "example":   password => 'use_a_bogus_hash_here_...XGdsiP2Q0';
  }
}
