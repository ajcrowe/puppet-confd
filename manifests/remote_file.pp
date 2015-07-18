# == Resource confd::remote_file
#
define confd::remote_file($url, $owner='root', $mode='0750', $links='follow') {

  include confd

  $wget_cmd = "/usr/bin/wget -q"
  $exists_check = "/usr/bin/test -f ${title}"
  $version_check = "/usr/bin/test `${title} --version | awk '{print \$2}'` = '${confd::version}'"

  exec { "download_${title}":
    command => "${wget_cmd} ${url} -O ${title}",
    unless => "${exists_check} && ${version_check}"
  }

  file { $title:
    ensure => present,
    mode => $mode,
    owner => $owner,
    links => $links,
    require => Exec["download_${title}"],
  }
}
