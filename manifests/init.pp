class sogo (
  $sogo_db_password,
  $sogo_workers_count        = 3,
  $sogo_enabledomainbaseduid = true,
  $imap_server               = 'localhost',
  $smtp_server               = 'localhost',
  $sieve_server              = 'sieve://localhost:2000',
) {

  Class['sogo::install'] -> Class['sogo::config'] ~> Class['sogo::service']

  class { 'sogo::install':
    sogo_db_password   => $sogo_db_password
  }
  class { 'sogo::config':
    sogo_db_password   => $sogo_db_password,
    sogo_workers_count => $sogo_workers_count,
    sogo_enabledomainbaseduid => $sogo_enabledomainbaseduid,
    imap_server        => $sogo::imap_server,
    smtp_server        => $sogo::smtp_server,
    sieve_server       => $sogo::sieve_server,
  }
  class { 'sogo::service': } 
}

