class sogo::config (
  $sogo_db_password,
  $sogo_workers_count,
  $sogo_enabledomainbaseduid,
  $imap_server,
  $smtp_server,
  $sieve_server,
) {
  
  concat { '/home/sogo/GNUstep/Defaults/GNUstepDefaults':
    notify  => Exec ['update-sogo-config']
  }

  concat::fragment{ 'GNUstepDefaults_base' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 01,
    content => template('sogo/GNUstepDefaults_base.erb'),
  }

  @concat::fragment{ 'GNUstepDefaults_base_multi_domain' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 05,
    content => template('sogo/GNUstepDefaults_base_multi_domain.erb'),
  }

  @concat::fragment{ 'GNUstepDefaults_end_multi_domain' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 95,
    content => template('sogo/GNUstepDefaults_end_multi_domain.erb'),
  }

  concat::fragment{ 'GNUstepDefaults_end' :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 99,
    content => template('sogo/GNUstepDefaults_end.erb'),
  }

  #SOGo sometimes rewrite the configuration file. This will prevent Puppet from
  #continuoulsy overwritting the SOGO's rewritten version
  exec { 'update-sogo-config':
    command     => 'cp /home/sogo/GNUstep/Defaults/GNUstepDefaults /home/sogo/GNUstep/Defaults/.GNUstepDefaults',
    refreshonly => true,
  }

  file { '/etc/apache2/conf.d/SOGo.conf':
    ensure  => absent,
    notify  => Exec['reload-apache2']
  }
}

