A Puppet module for managing the installation and configuration of
[Diamond](https://github.com/python-diamond/Diamond).

[![PuppetForge](http://img.shields.io/puppetforge/v/lesaux/diamond.svg)](https://forge.puppetlabs.com/lesaux/diamond)
[![BuildStatus](https://secure.travis-ci.org/lesaux/puppet-diamond.png)](http://travis-ci.org/lesaux/puppet-diamond)


# Overview

Install and configure diamond. This is a fork from the garethr-diamond module.
Package is compiled and installed from releases at [Diamond github repo](https://github.com/python-diamond/Diamond).
Latest version is 4.0 at the time of writting this module.
The rest of the functionalities is identical to the garethr-diamond module.

# Usage

For experimenting you're probably fine just with:

```puppet
include diamond
```

This installs diamond but doesn't ship the metrics anywhere, it just
runs the archive handler.

## Configuration

This module currently exposes a few configurable options, for example 
the Graphite host and polling interval. So you can also do:

```puppet
class { 'diamond':
  graphite_host => 'graphite.example.com',
  graphite_port => 2013,
  interval      => 10,
}
```

You can also add additional collectors:

```puppet
diamond::collector { 'RedisCollector':
  options => {
    'instances' => 'main@localhost:6379, other@localhost:6380'
  }
}
```

Some collectors support multiple sections, for example the NetApp and RabbitMQ collectors

```puppet
diamond::collector { 'NetAppCollector':
  options => {
    'path_prefix' => '/opt/netapp/lib/python'
  },
  sections => {
    '[devices]' => {},
    '[[host01]]' => {
         'ip' => '10.10.10.1',
         'username' => 'bob',
         'password' => 'alice'
    },
    '[[host02]]' => {
         'ip' => '10.10.10.2',
         'username' => 'alice',
         'password' => 'bob'
    }
  }
}

diamond::collector { 'RabbitMQCollector':
  options => {
    'host' => '10.10.10.1',
    'user' => 'bob',
    'password' => 'alice'
  },
  sections => {
    '[vhosts]' => {
      '*' => '*'
    }
  }
}
```

Diamond supports a number of different handlers, for the moment this
module supports only the Graphite, Librato and Riemann handers. Pull request
happily accepted to add others.

With Librato:

```puppet
class { 'diamond':
  librato_user   => 'bob',
  librato_apikey => 'jim',
}
```

With Riemann:

```puppet
class { 'diamond':
  riemann_host => 'riemann.example.com',
}
```

Note that you can include more than one of these at once.

```puppet
class { 'diamond':
  librato_user   => 'bob',
  librato_apikey => 'jim',
  riemann_host   => 'riemann.example.com',
  graphite_host  => 'graphite.example.com',
}
```

