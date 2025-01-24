## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

# Determine the Puppet Infrastructure we are on based on the CA cert fingerprint
# To obtain the sha256 ca cert fingerprint on an agent by hand:
#    openssl x509 -noout -fingerprint -sha256 -inform pem -in /etc/puppetlabs/puppet/ssl/certs/ca.pem
case $facts['cacert_fingerprint'] {
  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa': {
    $puppet_infra = 'development'
  }
  'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb': {
    $puppet_infra = 'test'
  }
  default: {
    $puppet_infra = 'production'
  }
}

# notify { "message from hiera: ${lookup('message', {'default_value' => undef})}": }

# $keys = ['boolean_as_string', 'array_as_json', 'hash_as_json', 'user_hash', 'list_of_strings']
# $keys.each |String $key| {
#   $value = lookup($key)
#   notify { "${key} from hiera: ${type($value)} ${value}": }
# }

# $array_as_json = lookup('array_as_json')
# $array_parsed = parsejson($array_as_json, undef)
# notify { "array_as_json parsed: ${type($array_parsed)} ${array_parsed}": }

# $alias_somestring = lookup('alias_somestring')
# notify { "alias_somestring: ${type($alias_somestring)} ${alias_somestring}": }

# $alias_missingstring = lookup('alias_missingstring')
# notify { "alias_missingstring: ${type($alias_missingstring)} ${alias_missingstring}": }

# $missingkey = lookup('missingkey')
# notify { "missingkey: ${type($missingkey)} ${missingkey}": }

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}
