# == Class confd::install
#
class confd::install {
  include confd

  $binary_src = "puppet:///modules/${confd::sitemodule}/confd-${confd::version}"

  file { "${confd::installdir}/confd":
    ensure => present,
    links  => follow,
    owner  => 'root',
    mode   => '0750',
    source => $binary_src
  }

  # XXX: This is hard-coded upstart stuff
  file { '/etc/init/confd.conf':
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    content => template('confd/confd.upstart.erb'),
  }
  file { '/etc/init.d/confd':
    ensure => link,
    target => '/lib/init/upstart-job',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
