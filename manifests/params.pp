# == Class confd::params
#
# This class is meant to be called from confd
# It sets variables according to platform
#
class confd::params {
  $confdir    = '/etc/confd'
  $version    = 'latest'
  $user       = 'root'
  $enable     = true
  $ensure = 'running'
  $sitemodule = 'site_confd'
  $nodes      = ['127.0.0.1:4001']

  case $::osfamily {
    'Debian': {
      $installdir   = '/usr/local/bin'
    }
    'RedHat', 'Amazon': {
      $installdir   = '/usr/bin'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  case $::operatingsystemmajrelease {
    7, 8: {
      $init_template = 'confd/systemd.service.erb'
      $init_location = '/etc/systemd/system/confd.service'
    }
    default: {
      case $::osfamily {
        'Debian': {
          $init_template = 'confd/confd.conf.erb'
          $init_location = '/etc/init.d/confd.conf'
        }
        'Redhat', 'Amazon': {
          $init_template = 'confd/initd.erb'
          $init_location = '/etc/init.d/confd'
        }
        default: {
          fail("${::operatingsystem} not supported")
        }
      }
    }
  }

}
