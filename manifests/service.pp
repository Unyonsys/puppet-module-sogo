class sogo::service {
  service { 'sogo':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

  cron { 'sogo-ealarms-notify':
    command => '/usr/sbin/sogo-ealarms-notify',
    user    => 'sogo',
  }
}

