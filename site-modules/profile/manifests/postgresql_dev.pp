class profile::postgresql_dev () {
  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '12',
  }
  class { 'postgresql::server':
    postgres_password => 'fancydancy',
  }

}
