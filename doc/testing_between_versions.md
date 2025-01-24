# Testing between Puppet versions

## Manual catalog generation

After generating the catalog file the first line needs to be removed if it contains a log message to the console such as:

```
notice: Compiled catalog for node1.example in environment production in 0.01 seconds
```

### Puppet 2.7.26

```
mkdir -p /tmp/puppet_etc/puppet/ssl/ca && \
mkdir -p /tmp/puppet_var && \
puppet master --compile node1.example --confdir /tmp/puppet_etc/puppet --vardir /tmp/puppet_var > /tmp/puppet_2_7_catalog.pson
```

### Puppet 6.17

```
mkdir -p /tmp/puppet_etc/puppet/ssl/ca && \
mkdir -p /tmp/puppet_var && \
puppet catalog compile node1.example --confdir /tmp/puppet_etc/puppet --vardir /tmp/puppet_var > /tmp/puppet_6_17_catalog.json
```

## Manual catalog application

### Puppet 2.7.26

```
puppet apply --noop --catalog /tmp/puppet_2_7_catalog.pson
```

## Puppet 6.17

```
puppet apply --noop --catalog /tmp/puppet_6_17_catalog.json
```
