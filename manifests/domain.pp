define sogo::domain (
  $ldap_bind_dn,
  $ldap_bind_pw,
  $ldap_hostnames             = [ 'localhost' ],
  $sogo_website               = 'mail',
  $sogo_dav_website           = 'dav',
  $sogo_timezone              = 'Europe/Paris',
  $sogo_dst_folder_prefix     = '',
  $sogo_mailauxiliaryuseraccountsenabled = false, 
  $sogo_imaploginfieldname    = 'mail',
  $multi_domain_setup         = false
) {

  if $multi_domain_setup {
    realize Concat::Fragment ['GNUstepDefaults_base_multi_domain']
    realize Concat::Fragment ['GNUstepDefaults_end_multi_domain']
  }
  else {
    # This resource will ensure Puppet fails if somebody tries to declare multiple domains
    # in a single domain configuration mode
    file { '/home/sogo/GNUstep/Defaults/single_domain_setup':
      ensure  => file,
      content => 'This is a single domain setup',
    }
  }

  concat::fragment{ "GNUstepDefaults_${name}" :
    target  => '/home/sogo/GNUstep/Defaults/GNUstepDefaults',
    order   => 20,
    content => template("sogo/GNUstepDefaults_domain.erb")
  }

  file { "/home/sogo/SOGo_${name}.conf":
    ensure  => file,
    content => template('sogo/sogo.conf.erb'),
    require => Package['sogo'],
    notify  => Exec['reload-apache2']
  }

  file { "/home/sogo/SOGo_dav_${name}.conf":
    ensure  => file,
    content => template('sogo/sogo_dav.conf.erb'),
    require => Package['sogo'],
    notify  => Exec['reload-apache2']
  }

  file { "/etc/apache2/specific-includes/sogo-rewrite-${name}.conf":
    ensure  => file,
    content => template('sogo/sogo-rewrite.conf.erb'),
    require => Package['apache2'],
    notify  => Exec['reload-apache2']
  }
}
