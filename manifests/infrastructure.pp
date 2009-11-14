# infrastructure.pp 
#
# Defines overall infrastructure logic. Give information specific to various
# providers in use (prgmr.com, Slicehost, EC2, etc.) such as DNS. Nodes within
# the same provider should be in the same network and grouped accordingly.
#
# Note: These variables are static and can NOT be reassigned.

node basenode {
  # ref: <man resolv.conf>
  $domain      = ""                                    # One-word lookup suffix.
  $nameservers = ["208.67.220.220", "208.67.222.222"]  # Direct DNS queries to.
  $search      = $domain                               # Space-deliminated.
  $intranet    = ""
}

node prgmr inherits basenode {
  $domain      = "nekogiri.com"
  $nameservers = ["66.28.0.45", "66.28.0.61"]
  $search      = "${domain} xen.prgmr.com"
  $intranet    = ""
}

node ec2 inherits basenode {
}

node cpc inherits basenode {
  $domain      = "nekogiri.com"
  $nameservers = ["208.67.220.220","4.2.2.3","4.2.2.2","4.2.2.4"]
  $search      = "${domain} local"
  $intranet    = "67.58.98.8/29"

  # Domains I'll accept mail for.
  $local_domains = [
    "nekogiri.com", 
    "cmudso.org", 
    "friedneko.com",
    "dsoglobal.org",
  ]
}
