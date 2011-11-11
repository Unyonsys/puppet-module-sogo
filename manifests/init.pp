class sogo (
  $sogo_db_password,
  $sogo_workers_count = 3
  ) {

  Mysql::Database['sogo']         -> Class['sogo']
  Mysql::User['sogo']             -> Class['sogo']
  Mysql::Rights::Standard['sogo'] -> Class['sogo']

  Class["${module}::install"] -> Class["${module}::config"] ~> Class["${module}::service"]

  class { "${module}::install": }
  class { "${module}::config":
    sogo_db_password   => $sogo_db_password,
    sogo_workers_count => $sogo_workers_count
  }
  class { "${module}::service": } 
}

