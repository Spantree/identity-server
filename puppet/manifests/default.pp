hiera_include('classes')

node default {

  $default_entries = '/tmp/default-entries.ldif'

  $import_ldap_data = '/tmp/initialize_ldap_data.sh'

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  class { 'openldap::server':
    databases              => {
      'dc=spantree,dc=net' => {
        directory          => '/var/lib/ldap',
        rootdn             => 'cn=admin,dc=spantree,dc=net',
        rootpw             => '{SSHA}KueX2WDOUm5kYGo36+G0iAw30/AoOf6a',
      }
    },
    suffix                 => 'dc=spantree,dc=net',
  }

  openldap::server::access {
    'to attrs=userPassword,shadowLastChange by dn="cn=admin,dc=spantree,dc=net" on dc=spantree,dc=net': access => 'write';
    'to attrs=userPassword,shadowLastChange by anonymous on dc=spantree,dc=net': access => 'auth';
    'to attrs=userPassword,shadowLastChange by self on dc=spantree,dc=net': access => 'write';
    'to attrs=userPassword,shadowLastChange by * on dc=spantree,dc=net': access => 'none';
  }

  openldap::server::access {
    'to dn.base="" by * on dc=spantree,dc=net': access => 'read',
  }

  openldap::server::access {
    'to * by dn="cn=admin,dc=spantree,dc=net" on dc=spantree,dc=net': access => 'write';
    'to * by * on dc=spantree,dc=net': access => 'read';
  }

  openldap::server::module { 'memberof':
    ensure => present,
  }

  openldap::server::overlay { 'memberof on dc=spantree,dc=net':
    ensure => present,
  } ->


  file { $default_entries:
    ensure  => file,
    source  => 'puppet:///modules/local_mod/ldap.ldif',
  } ->

  file { $import_ldap_data:
    ensure => file,
    source => 'puppet:///modules/local_mod/initialize_ldap_data.sh',
    mode   => '0755',
  } ->

  exec { 'import-ldap-data':
    command => "${import_ldap_data} ${default_entries}" ,
    require => [
      File[$default_entries],
      File[$import_ldap_data]
    ],
  }
}
