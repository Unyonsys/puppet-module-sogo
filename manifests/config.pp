class sogo::config (
  $sogo_db_password,
  $sogo_workers_count
  ) {
  
  concat { '/home/sogo/GNUstep/Defaults/GNUstepDefaults':
    notify  => Exec ['update-sogo-config']
  }

  concat::fragment{ 'GNUstepDefaults_base' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 01,
    content => template('sogo/GNUstepDefaults_base.erb'),
  }

  concat::fragment{ 'GNUstepDefaults_end' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 99,
    content => template('sogo/GNUstepDefaults_end.erb'),
  }

  exec { 'update-sogo-config':
    command     => 'cp /home/sogo/GNUstep/Defaults/GNUstepDefaults /home/sogo/GNUstep/Defaults/.GNUstepDefaults',
    refreshonly => true,
  }

  file { '/etc/apache2/conf.d/SOGo.conf':
    ensure  => absent,
    notify  => Exec['reload-apache2']
  }
}

