# Internal class to start up systemd
class confd::service {
  service { 'confd':
    ensure    => $::confd::ensure,
    hasstatus => true,
    enable    => $::confd::enable,
  }
}
