# sets up metrics collection
class profile::puppet::puppet_metrics {
  # include puppet_metrics_collector
  # include puppet_metrics_collector::system

  # include puppet_metrics_dashboard::profile::master::install
  # include puppet_metrics_dashboard::profile::master::postgres_access
}
