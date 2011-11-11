class sogo (
  $sogo_db_password,
  $sogo_workers_count = 3
) {

  Class["${module}::install"] -> Class["${module}::config"] ~> Class["${module}::service"]

  class { "${module}::install":
    sogo_db_password   => $sogo_db_password
  }
  class { "${module}::config":
    sogo_db_password   => $sogo_db_password,
    sogo_workers_count => $sogo_workers_count
  }
  class { "${module}::service": } 
}

