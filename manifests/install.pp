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

  case $::osfamily {
    'debian': {
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
    'redhat': {
      file { '/etc/init.d/confd':
        ensure => present,
        content => template('confd/confd.sysv.erb'),
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      service { 'confd':
        enable => true,
      }
    }

    default: {
      fail("Unsupported OS Family: $::osfamily")
    }
  }
}
