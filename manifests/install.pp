# == Class confd::install
#
class confd::install {
  include confd

  $binary_src = "puppet:///modules/${confd::sitemodule}/confd-${confd::version}"
  $binary_dst = "${confd::installdir}/confd"

  $owner = 'root'
  $mode = '0750'
  $links = 'follow'

  if $confd::downloadurl {
    confd::remote_file { $binary_dst:
      url => $confd::downloadurl,
      links => $links,
      owner => $owner,
      mode  => $mode,
    }
  } else {
    file { $binary_dst: 
      ensure  => present,
      source => $binary_src,
      links => $links,
      owner => $owner,
      mode  => $mode,
    }
  }
}
