class sogo (
  $sogo_db_password,
  $sogo_workers_count = 3
) {

  Class['sogo::install'] -> Class['sogo::config'] ~> Class['sogo::service']

  class { 'sogo::install':
    sogo_db_password   => $sogo_db_password
  }
  class { 'sogo::config':
    sogo_db_password   => $sogo_db_password,
    sogo_workers_count => $sogo_workers_count
  }
  class { 'sogo::service': } 
}

