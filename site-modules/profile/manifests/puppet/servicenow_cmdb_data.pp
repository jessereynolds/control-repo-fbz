# Customise how we use servicenow_cmdb_data module
class profile::puppet::servicenow_cmdb_data {

  class { 'servicenow_cmdb_data':
    servicenow_endpoint => 'https://example.service-now.com/api/now/table/cmdb_ci_server',
    servicenow_username => 'abc',
    servicenow_password => '123',
  }

}

