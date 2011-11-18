define sogo::domain (
  $ldap_bind_dn,
  $ldap_bind_pw,
  $sogo_website               = 'mail',
  $sogo_dav_website           = 'dav',
  $sogo_website_aliases       = false,
  $sogo_website_fqdnaliases   = false,
  $sogo_timezone              = 'Europe/Paris',
  $sogo_dst_folder_prefix     = 'INBOX/',
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

  apache2::website { "${sogo_website}.${name}":
      site_domain         => $name,
      confname            => $sogo_website,
      apache2_aliases     => $sogo_website_aliases,
      apache2_fqdnaliases => $sogo_website_fqdnaliases,
      required_modules    => ['proxy', 'proxy_http', 'headers'],
      apache2_includes    => ["/home/sogo/SOGo_${name}.conf", "/etc/apache2/specific-includes/sogo-rewrite-${name}.conf"],
      site_ips_ssl        => '*',
      force_ssl           => true,
      has_awstats         => false,
  }

  apache2::website { "${sogo_dav_website}.${name}":
      site_domain         => $name,
      confname            => $sogo_dav_website,
      required_modules    => ['proxy', 'proxy_http', 'headers'],
      apache2_includes    => ["/home/sogo/SOGo_dav_${name}.conf"],
      site_ips_ssl        => '*',
      force_ssl           => true,
      has_awstats         => false,
      monitor             => 'with_auth'
  }
}
