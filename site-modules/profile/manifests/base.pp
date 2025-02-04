# the base profile should include component modules that will be on all nodes
class profile::base {
  case fact('os.family') {
    'redhat','debian': {
      include profile::base_linux
    }
    default: {}
  }
}
