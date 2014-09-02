# == Class: confd
#
# Class to install and configure all the options for confd.toml
#
class confd(
  $version     = $confd::params::version,
  $installdir  = $confd::params::installdir,
  $sitemodule  = $confd::params::sitemodule,

  $confdir     = $confd::params::confdir,
  $backend     = undef,
  $debug       = undef,
  $client_cert = undef,
  $client_key  = undef,
  $consul      = undef,
  $consul_addr = undef,
  $etcd_nodes  = undef,
  $etcd_scheme = undef,
  $interval    = undef,
  $confdnoop   = undef,
  $prefix      = undef,
  $quiet       = undef,
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
  if $consul { validate_bool($consul) }
  if $consul_addr { validate_string($consul_addr) }
  if $etcd_nodes { validate_array($etcd_nodes) }
  if $etcd_scheme { validate_re($etcd_scheme, '^https?$') }
  if $interval { validate_re($interval, '^\d+') }
  if $confdnoop { validate_bool($confdnoop) }
  if $prefix { validate_string($prefix) }
  if $quiet { validate_bool($quiet) }
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
  class { 'confd::config': } ~>
  Class['confd']
}
