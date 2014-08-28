# == Class confd::service
#
# This class is meant to be called from confd
# It ensure the service is running
#
class confd::service {
  include confd::params

  service { $confd::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
