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
}
