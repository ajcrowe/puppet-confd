# == Class confd::service
#
class confd::service {
  service { 'confd':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
