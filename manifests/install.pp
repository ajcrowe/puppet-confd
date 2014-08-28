# == Class confd::install
#
class confd::install {
  include confd

  $binarysrc = "puppet:///modules/${confd::sitemodule}/confd-${confd::version}"

  file { "${confd::installdir}/confd":
    ensure => present,
    owner  => 'root',
    mode   => '0755',
    source => $binarysrc
  }
}
