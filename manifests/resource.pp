# == Define confd::resource
#
# This define is to create a resource in confd.
# confd will populate the template with the given data
#
define confd::resource(
  $src,
  $dest,
  $keys,
  $ensure     = present,
  $group      = undef,
  $mode       = undef,
  $owner      = undef,
  $reload_cmd = undef,
  $check_cmd  = undef,
  $prefix     = undef
) {

  # validate required params
  validate_absolute_path($dest)
  validate_array($keys)
  validate_string($src)
  # validate optional params
  if $group { validate_string($group) }
  if $owner { validate_string($owner) }
  if $reload_cmd { validate_string($reload_cmd) }
  if $check_cmd { validate_string($check_cmd) }
  if $prefix { validate_string($prefix) }

  $resourcefile = "${confd::confdir}/conf.d/${name}.toml"

  file { $resourcefile:
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0750',
    content => template('confd/resource.toml.erb'),
    notify  => Class['confd::service']
  }
}