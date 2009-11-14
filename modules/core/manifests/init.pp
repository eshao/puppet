# module: core/init.pp
#
# For magic lookup: http://reductivelabs.com/trac/puppet/wiki/ModuleOrganisation
#
# Uses naming of files to specify:
# -- per-os files
# -- per-host files

import '*'

class core {
  Sync { prefix => "/etc", module => "core" }
  Itpl { prefix => "/etc", module => "core" }

  # Sync files.
  # localtime from /usr/share/zoneinfo.
  sync { ["make.conf", "ntp.conf", "sysctl.conf", "pf.conf", "localtime"]: }
  itpl { ["resolv.conf", "hosts", "rc.conf", "rc.local"]: }
}

