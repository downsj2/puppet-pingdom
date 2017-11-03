# puppet-pingdom
Puppet type and provider for Pingdom API

Not done yet. Basic check functionality works (create/delete/update),
but needs user/group stuff done. Also, needs better error-handling.

```puppet
pingdom_check { "http://${facts['hostname']}/check":
    ensure   => present,
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',
    
    # provider-specific properties
    provider => 'http',
    host     => $facts['hostname'],
    url      => '/check',

    # common properties
    paused   => true,
    tags     => [ 'web', 'sales' ]
}
```
