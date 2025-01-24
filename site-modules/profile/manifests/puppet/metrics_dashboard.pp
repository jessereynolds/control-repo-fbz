# sets up grafana etc
class profile::puppet::metrics_dashboard {
  class { 'puppet_metrics_dashboard':
    add_dashboard_examples => true,
    overwrite_dashboards   => false,
  }
}
