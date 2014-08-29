# Puppet Confd

[![Build Status](https://travis-ci.org/ajcrowe/puppet-confd.png?branch=master)](https://travis-ci.org/ajcrowe/puppet-confd)


1. [Overview](#overview)
2. [Setup](#setup)
    * [The confd class](#the-confd-resource-define)
    * [The confd::resource define](#the-confd-resource-define)
    * [Beginning with confd](#beginning-with-confd)
3. [Examples](#examples)
4. [Development](#development)

##Overview

This module allow you to manage your [confd](https://github.com/kelseyhightower/confd) templates and resources in Puppet. All configuration options are available and can be defined in Hiera

This module will install, configure and manage your resources and templates.

##Setup

Once you have this module installed you'll need a site module to store your templates and ssl certficates (if you're using them).

It should have the following structure:

```
site_confd
└── files
    ├── confd-0.5.0
    ├── confd-x.x.x
    ├── confd-latest -> confd-0.5.0
    ├── ssl
    │   ├── ssl.crt
    │   └── ssl.key
    └── templates
        ├── resource1.tmpl
        ├── resource2.tmpl
        └── ...
```

You'll need to download the confd [binary](https://github.com/kelseyhightower/confd/releases) of you choice and ensure it matches `confd-$version`, the default value for version is latest. This allows you to run multiple versions of confd should you wish, can you symlink the default to `confd-latest`. You can also customise the name of site module by setting the `confd::sitemodule` param.

To setup confd with all defaults you can simply include the class 

```ruby
include confd
```

This will copy the confd binary and create all the directory structure

###The confd class

####Parameters

These params are available to the confd class:

#####`version`

Integer: default to latest

This sets the confd binary to be installed from the site module

#####`installdir`

Absolute path: defaults to /usr/local/bin for Debian and /usr/bin for RedHat/Amazon

This set where the confd binary will be stored

#####`sitemodule`

String: defaults to site_confd 

Specifies the name of the site module for templates, ssl certs and binaries

#####`confdir`

Absolute path: defaults to /etc/confd/ 

Specifies where all the configuration for confd will live

##### Other Parameters

All other parameters are directly mapped to the configuration in `confd.toml please see the [documentation](https://github.com/kelseyhightower/confd/blob/master/docs/configuration-guide.md) for full details.

###The confd::resource define

####Parameters

Please see the confd [docs](https://github.com/kelseyhightower/confd/blob/master/docs/template-resources.md) for the available parameters, they are mapped directly and have validation checks based on the types.

##Examples

###Install confd with etcd backend and define a resource

```ruby
class { 'confd':
  etcd_nodes => [ 'http://etcd-1:4001', 'http://etcd-2:4001' ],
  interval   => 10
  prefix     => '/confd'
}

confd::resource { 'nginx_upstream_01':
  dest       => '/etc/nginx/conf.d/upstream_01.conf',
  src        => 'nginx_upstream.tmpl',
  keys       => [ '/nginx/upstream/01' ],
  group      => 'root',
  owner      => 'root',
  mode       => 0644,
  check_cmd  => '/usr/sbin/nginx -t',
  reload_cmd => '/usr/sbin/nginx -s reload'  
}
```

The `src` in the resource will be looking for a template in `/etc/confd/templates/nginx_upstream.tmpl`

## Development

If you have suggestions or improvements please file an issue or submit as pull request, i'll try and sort them as quickly as possble.

If you submit a pull please try and include tests for the new functionality/fix. The module is tested with [Travis-CI](https://travis-ci.org/ajcrowe/puppet-confd).

