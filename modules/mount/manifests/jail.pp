# module: mount/jail.pp

class mount::jail {
  # Generates an fstab to support jail (fstab.<hostname>)
  define generate {
    # Format: /usr/jails/basejail /usr/jails/neko/basejail nullfs ro 0 0
    # Note: mounted does not work with custom fstab name. Present works fine:
    # -- When mounted, can't edit file.
    # -- When unmounted, creates file to specifications.
    if exists("/usr/jails/$name/basejail") {
      mount { "fstab.${name}::basejail":
        device  => "/usr/jails/basejail",
        name    => "/usr/jails/$name/basejail",
        fstype  => "nullfs",
        options => "ro,noatime",
        dump    => 0,
        pass    => 0,
        ensure  => present,
        target  => dash2underscore("/etc/fstab.$name"),
      }
    }
    
    # Allows one set of ports to be shared.
    # ref: <http://www.cyberciti.biz/faq/freebsd-mount_nullf-usrports-inside-jail/>
    #
    # Could also have just kept the real directory in fulljail/usr/ports
    # and symlinked from /usr/jails, but would not have flexibility to not 
    # mount ports. NOTE: Ended up doing this, as was easier.
#    if exists("/usr/jails/$name/usr/ports") {
#      file { "/usr/jails/$name/usr/ports": ensure => directory }
#      mount { "fstab.${name}::ports":
#        device  => "/usr/ports",
#        name    => "/usr/jails/$name/usr/ports",
#        fstype  => "nullfs",
#        options => "ro,noatime",
#        dump    => 0,
#        pass    => 0,
#        ensure  => present,
#        target  => dash2underscore("/etc/fstab.$name"),
#        require => File["/usr/jails/$name/usr/ports"],
#      }
#    }
  }
}
