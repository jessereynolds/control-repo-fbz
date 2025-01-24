# Ensures a Windows computer's name corresponds to the trusted hostname from the SSL certificate
# Refer: https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.management/rename-computer
#
class profile::computer_name {
  $computer_name = sprintf('%.15s', downcase($trusted['hostname']))
  $command       = "Rename-Computer -NewName ${computer_name} -Restart"

  exec { 'rename_computer':
    command   => "if (${command}) { exit 0 } else { exit 1 }",
    unless    => "if ((hostname) -eq '${computer_name}') { exit 0 } else { exit 1 }",
    provider  => powershell,
    logoutput => true,
    notify    => Reboot['after_rename'],
  }

  reboot { 'after_rename':
    when => refreshed,
  }
}
