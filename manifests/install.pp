# == Class confd::install
#
class confd::install {
  include confd

  $binarysrc = "puppet:///modules/${confd::sitemodule}/confd-${confd::version}"

  file { "${confd::installdir}/confd":
    ensure => present,
    links  => follow,
    owner  => 'root',
    mode   => '0750',
    source => $binarysrc
  }
}
