class sogo (
  $sogo_db_password,
  $sogo_workers_count = 3
  ) {
  
  class { 'apt::repository::inverse': stage => pre }
  package { 'sogo':
    ensure  => present,
    require => [ Mysql::Database['sogo'], Mysql::User['sogo'], Mysql::Rights::Standard['sogo'] ]
    }
  
  concat { '/home/sogo/GNUstep/Defaults/GNUstepDefaults':
    require => Package['sogo'],
    notify  => Exec ['update-sogo-config']
  }

  concat::fragment{ 'GNUstepDefaults_base' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 01,
    content => template("sogo/GNUstepDefaults_base.erb"),
  }

  concat::fragment{ 'GNUstepDefaults_end' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 99,
    content => template("sogo/GNUstepDefaults_end.erb"),
  }

  exec { 'update-sogo-config':
    command     => 'cp /home/sogo/GNUstep/Defaults/GNUstepDefaults /home/sogo/GNUstep/Defaults/.GNUstepDefaults',
    refreshonly => true,
    notify      => Service['sogo']
  }

  service { 'sogo':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['sogo']
  }
  
  file { '/etc/apache2/conf.d/SOGo.conf':
    ensure  => absent,
    require => Package['sogo'],
    notify  => Exec['reload-apache2']
  }

  cron { 'sogo-ealarms-notify':
    command => '/usr/sbin/sogo-ealarms-notify',
    user    => 'sogo',
  }
}
