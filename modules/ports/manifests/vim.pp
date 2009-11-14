class ports::vim { 
  package { 'vim': ensure => present, provider => freebsd }
}