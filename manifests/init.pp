# == Class: confd
#
# Class to install and configure all the options for confd.toml
#
class confd(
  $version       = $confd::params::version,
  $installdir    = $confd::params::installdir,
  $sitemodule    = $confd::params::sitemodule,
  $downloadurl   = $confd::params::downloadurl,

  $confdir       = $confd::params::confdir,
  $nodes         = $confd::params::nodes,
  $backend       = undef,
  $debug         = undef,
  $client_cakeys = undef,
  $client_cert   = undef,
  $client_key    = undef,
  $interval      = undef,
  $confdnoop     = undef,
  $log_level     = undef,
  $prefix        = undef,
  $quiet         = undef,
  $scheme        = undef,
  $srv_domain    = undef,
  $verbose       = undef,
  $watch         = undef,
  $resources     = {},

) inherits confd::params {

  # validate parameters here
  validate_string($version)
  validate_absolute_path($installdir)
  validate_string($sitemodule)
  validate_absolute_path($confdir)
  validate_hash($resources)

  if $downloadurl { validate_string($downloadurl) }
  if $backend { validate_re($backend, ['^etcd$', '^consul$', '^zookeeper$', '^dynamodb$', '^redis$', '^env$']) }
  if $debug { validate_bool($debug) }
  if $interval { validate_re($interval, '^\d+') }
  if $confdnoop { validate_bool($confdnoop) }
  if $log_level { validate_re($log_level, ['^debug$', '^info$', '^warn(ing)?$', '^error$', '^fatal$', '^panic$']) }
  if $nodes { validate_array($nodes) }
  if $prefix { validate_string($prefix) }
  if $quiet { validate_bool($quiet) }
  if $scheme { validate_re($scheme, '^https?$') }
  if $srv_domain { validate_string($srv_domain) }
  if $verbose { validate_bool($verbose) }
  if $watch { validate_bool($watch) }
  if $client_cakeys {
    validate_string($client_cakeys)
    $client_cakeys_path = "${confdir}/ssl/${client_cakeys}"
  }
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
