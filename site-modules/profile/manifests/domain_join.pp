# Ensures the Windows computer is joined to the Active Directory Domain
class profile::domain_join {

  $base_dn = 'OU=computers,DC=example,DC=com'
  $domain = 'example.com'

  case $facts['os']['release']['major'] {
    /^2012/: {
      case $::site {
        'aws_sydney': { $machine_ou = "OU=aws,OU=W2012,${base_dn}" }
        default: {
          fail("Unrecognised site (${::site}) - unable to determine machine_ou for domain join")
        }
      }
    }
    /^2008/: {
      case $::site {
        'aws_sydney': { $machine_ou = "OU=AWS,OU=W2008,${base_dn}" }
        default: {
          fail("Unrecognised site (${::site}) - unable to determine machine_ou for domain join")
        }
      }
    }
    default: {
      fail("Unrecognised os.release.major (${facts['os']['release']['major']}) - unable to determine machine_ou for domain join")
    }
  }

  class { 'domain_membership':
    domain       => $domain,
    username     => 'svc_puppetadbind',
    password     => 'xxxxxxxx',
    machine_ou   => $machine_ou,
    reboot       => true,
    join_options => '3',
    require      => Reboot['after_rename'],
  }

}
