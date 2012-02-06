class sogo (
  $sogo_db_password,
  $sogo_workers_count        = 3,
  $sogo_enabledomainbaseduid = true,
) {

  Class['sogo::install'] -> Class['sogo::config'] ~> Class['sogo::service']

  class { 'sogo::install':
    sogo_db_password   => $sogo_db_password
  }
  class { 'sogo::config':
    sogo_db_password   => $sogo_db_password,
    sogo_workers_count => $sogo_workers_count,
    sogo_enabledomainbaseduid => $sogo_enabledomainbaseduid,
  }
  class { 'sogo::service': } 
}

