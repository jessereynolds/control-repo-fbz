# Manage the Puppet Agent
class profile::puppet::agent (
  Optional[String[1]] $server_list = undef
) {

  # exclude this class on PE infrastructure servers
  if $server_list and ! $facts['pe_build'] {

    include puppet_agent

    ini_setting { 'puppet.conf main server_list':
      ensure  => present,
      path    => $facts['puppet_config'],
      section => 'main',
      setting => 'server_list',
      value   => $server_list,
    }

    ini_setting { 'puppet.conf main server':
      ensure  => absent,
      path    => $facts['puppet_config'],
      section => 'main',
      setting => 'server',
    }

    ini_setting { 'puppet.conf agent server_list':
      ensure  => absent,
      path    => $facts['puppet_config'],
      section => 'agent',
      setting => 'server_list',
    }

    ini_setting { 'puppet.conf agent server':
      ensure  => absent,
      path    => $facts['puppet_config'],
      section => 'agent',
      setting => 'server',
    }

  }
}
