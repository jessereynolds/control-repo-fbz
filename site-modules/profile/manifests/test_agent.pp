# This profile demonstrates setting of defaults and
# overrides entirely in hiera
class profile::test_agent (
  Hash $config, # setting no default will fail early if data is not found by hiera
) {
  class { 'test_agent':
    * => $config,
  }
}
