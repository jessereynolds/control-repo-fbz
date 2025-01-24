# Ensures existence of an admin group in AD for this Windows computer
class profile::computer_admin_ad_group {
  $username   = 'svc_puppetadbind'
  $password   = 'xxxxxxxx'
  $servername = upcase($trusted['hostname'])
  $group_name = "Right-ADM-SV-Server.${servername}.LocalAdmin-U-GS"
  $group_path = 'OU=AdminRights,OU=Groups,DC=EXAMPLE,DC=COM'

  windowsfeature { 'ad-domain-services':
    ensure => 'present',
  }

  $set_credentials = join([
    '$username = "', $username, '" ; ',
    '$password = ConvertTo-SecureString "', $password, '" -AsPlainText -Force ; ',
    '$credentials = new-object System.Management.Automation.PSCredential($username,$password) ; ',
    ], '')

  $test_group_existence = join([
    $set_credentials,
    'try { Get-ADGroup -Credential $credentials "', $group_name, '" } ',
    'catch { echo "ERROR: $_ " ; exit 1 }',
    ], '')

  $create_group = join([
    $set_credentials,
    'try { New-adgroup -Credential $credentials –Name "', $group_name,
    '" –Path "', $group_path, '" –GroupCategory Security –GroupScope Global } ',
    'catch { echo "ERROR: $_ " ; exit 1 }',
    ], '')

  exec {'ensure_admin_group':
    provider => 'powershell',
    command  => $create_group,
    unless   => $test_group_existence,
    require  => Windowsfeature['ad-domain-services'],
  }

  group {'Administrators':
    ensure  => present,
    members => [
      'Administrator',
      'EXAMPLE\Domain Admins',
      "EXAMPLE\\Right-ADM-SV-Server.${servername}.LocalAdmin-U-GS",
    ],
    require => Exec['ensure_admin_group'],
  }

}
