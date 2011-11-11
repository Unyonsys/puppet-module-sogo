class sogo::database (
  $sogo_db_password
  ) {
  
  mysql::user { 'sogo':
    user      => sogo,
    password  => $sogo_db_password,
  }
  mysql::rights::standard { 'sogo':
    database  => 'sogo',
    user      => 'sogo',
  }
  mysql::database { 'sogo': }
}
