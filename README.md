# Puppet-jails

Manage FreeBSD Jails with puppet.

## Simple implementation

All parameters from [jail(8)](http://www.freebsd.org/cgi/man.cgi?query=jail&sektion=8) are applicable to either the class defaults or to any jail.

```Puppet

class { 'jails':
  defaults => {
    'interface'   => 'em0',
    'allow_mount' => true,
    'exec_start'  => '/bin/sh /etc/rc',
    'exec_stop'   => '/bin/sh /etc/rc.shutdown',
    'exec_clean'  => true,
    'mount_devfs' => true,
  }
}

jails::jail { 'webserver0':
  path          => '/jails/webserver0',
  ip4_addr      => '192.168.0.5',
  host_hostname => 'webserver0.example.org',
}
```

Jails can be easily managed from Hiera as well:
```YAML
jails::jails:
  webserver0:
    path:          '/jails/webserver0'
    ip4_addr:      '192.168.0.5'
    host_hostname: 'webserver0.example.org'
```
