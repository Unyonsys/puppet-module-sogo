class sogo::install (
  $sogo_db_password
) {
  package { 'sogo':
    ensure => present
  }

  mysql::user { 'sogo':
    password  => $sogo_db_password,
  }
  mysql::rights::standard { 'sogo':
    database  => 'sogo',
    user      => 'sogo',
  }
  mysql::database { 'sogo': }
}

