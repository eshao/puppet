# site.pp
#
# ref: <http://www.example42.com:811/wiki/HowTo>

$puppetmasterd_ip = '38.99.2.39'

import "infrastructure"
import "macros"
import "roles"
import "defaults"
import "nodes"

