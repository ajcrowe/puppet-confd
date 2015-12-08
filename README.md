# Puppet Confd

[![Puppet Forge](http://img.shields.io/puppetforge/v/ajcrowe/confd.svg)](https://forge.puppetlabs.com/ajcrowe/confd)
[![Build Status](https://travis-ci.org/ajcrowe/puppet-confd.png?branch=master)](https://travis-ci.org/ajcrowe/puppet-confd)


1. [Overview](#overview)
2. [Setup](#setup)
    * [The confd class](#the-confd-class)
    * [The confd resource define](#the-confd-resource-define)
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

You'll need to download the confd [binary](https://github.com/kelseyhightower/confd/releases) of you choice and ensure it matches `confd-$version`, the default value for version is latest. This allows you to run multiple versions of confd should you wish, can you symlink the default to `confd-latest`. 

You can also customise the name of site module by setting the `confd::sitemodule` param.

To setup confd with all defaults you can simply include the class 

```ruby
include confd
```

This will copy the `confd` binary and create all required the directory structure and sync your assets from the site module.

###The confd class

####Parameters

These params are available to the confd class:

#####`version`

Integer: defaults to `latest`

Description: This sets the confd binary to be installed from the site module

#####`installdir`

Absolute path: defaults to `/usr/local/bin` for Debian and `/usr/bin` for RedHat/Amazon

Description: This set where the confd binary will be stored

#####`sitemodule`

String: defaults to `site_confd`

Description: Specifies the name of the site module for templates, ssl certs and binaries

#####`confdir`

Absolute path: defaults to `/etc/confd/`

Description: Specifies where all the configuration for confd will live

#####`downloadurl`

URL: defaults to `undef`.

Description: If set, the confd binary will be downloaded from this url instead of being taken from the sitemodule. Currently requires that the `version` parameter is set to the actual value reported by `confd --version` to ensure we have the required binary in place (the default `latest` value should be changed).

##### Other Parameters

All other parameters are directly mapped to the configuration in `confd.toml` please see the [documentation](https://github.com/kelseyhightower/confd/blob/master/docs/configuration-guide.md) for full details.

###The confd resource define

####Parameters

Please see the confd [documentation](https://github.com/kelseyhightower/confd/blob/master/docs/template-resources.md) for the available parameters, they are mapped directly and have validation checks based on the types.

##Examples

###Install confd with etcd backend and define a resource

```ruby
class { 'confd':
  nodes    => [ 'etcd-1:4001', 'etcd-2:4001' ],
  interval => 10
  prefix   => '/confd'
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

The `src` value in the resource will be looking for a template in `/etc/confd/templates/nginx_upstream.tmpl` so this will need to exist in the sites module under `files/templates/nginx_upstream.tmpl`

###Hiera resource lookup

You can also define your resources in hiera under the variable `confd::resources` and these will automatically be created when the `confd` class is instantiated.

####Example JSON hiera:

```json
"confd::resources": { 
  "nginx_upstream_01": {
    "dest": "/etc/nginx/conf.d/upstream_01.conf",
    "src": "nginx_upstream.tmpl",
    "keys": [ 
      "/nginx/upstream/01"
    ],
    "group": "root",
    "owner": "root",
    "mode": "0644",
    "check_cmd": "/usr/sbin/nginx -t",
    "reload_cmd": "/usr/sbin/nginx -s reload"
  },
  "nginx_upstream_02": {
    "dest": "/etc/nginx/conf.d/upstream_02.conf",
    "src": "nginx_upstream.tmpl",
    "keys": [ 
      "/nginx/upstream/02"
    ],
    "group": "root",
    "owner": "root",
    "mode": "0644",
    "check_cmd": "/usr/sbin/nginx -t",
    "reload_cmd": "/usr/sbin/nginx -s reload"
  }
}
```

## Development

If you have suggestions or improvements please file an issue or submit as pull request, i'll try and sort them as quickly as possble.

If you submit a pull please try and include tests for the new functionality/fix. The module is tested with [Travis-CI](https://travis-ci.org/ajcrowe/puppet-confd).

