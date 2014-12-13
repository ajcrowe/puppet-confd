# == Class: confd
#
# Class to install and configure all the options for confd.toml
#
class confd(
  $version     = $confd::params::version,
  $installdir  = $confd::params::installdir,
  $sitemodule  = $confd::params::sitemodule,

  $confdir     = $confd::params::confdir,
  $nodes       = $confd::params::nodes,
  $backend     = undef,
  $debug       = undef,
  $client_cert = undef,
  $client_key  = undef,
  $interval    = undef,
  $confdnoop   = undef,
  $prefix      = undef,
  $quiet       = undef,
  $scheme      = undef,
  $srv_domain  = undef,
  $verbose     = undef,

  $resources = {},

) inherits confd::params {

  # validate parameters here
  validate_string($version)
  validate_absolute_path($installdir)
  validate_string($sitemodule)
  validate_absolute_path($confdir)
  validate_hash($resources)

  if $backend { validate_re($backend, ['^etcd$', '^consul$']) }
  if $debug { validate_bool($debug) }
  if $interval { validate_re($interval, '^\d+') }
  if $confdnoop { validate_bool($confdnoop) }
  if $nodes { validate_array($nodes) }
  if $prefix { validate_string($prefix) }
  if $quiet { validate_bool($quiet) }
  if $scheme { validate_re($scheme, '^https?$') }
  if $srv_domain { validate_string($srv_domain) }
  if $verbose { validate_bool($verbose) }
  if $client_cert {
    validate_string($client_cert)
    $client_cert_path = "${confdir}/ssl/${client_cert}"
  }
  if $client_key {
    validate_string($client_key)
    $client_key_path = "${confdir}/ssl/${client_key}"
  }

  create_resources('confd::resource', $resources)

  class { 'confd::install': } ->
  class { 'confd::config': } ->
  Confd::Resource <||>
}
