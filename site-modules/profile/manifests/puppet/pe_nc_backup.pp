# pe_nc_backup profile
class profile::puppet::pe_nc_backup {
  class { 'pe_nc_backup':
    cron_hour   => '*',
    cron_minute => '*',
  }
}
