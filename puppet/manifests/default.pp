hiera_include('classes')

node default {

  class { 'openldap::server':
    databases              => {
      'dc=spantree,dc=net' => {
        directory          => '/var/lib/ldap',
        rootdn             => 'cn=admin,dc=spantree,dc=net',
        rootpw             => '{SHA}qUqP5cyxm6YcTAhz05Hph5gvu9M=',
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
  } ->
  openldap::server::overlay { 'memberof on dc=spantree,dc=net':
    ensure => present,
  }
}
