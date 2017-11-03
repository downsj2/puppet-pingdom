# puppet-pingdom
Puppet type and provider for Pingdom API

Not done yet. Basic check functionality works (create/delete/update), 
but needs user/group stuff done. Also, needs better error-handling.

```puppet
pingdom { $facts['hostname']:
    ensure   => absent,
    provider => 'http',
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',
    paused   => true,

    params => {
        host => $facts['hostname'],
        url  => '/check',
    }

    # resolution => undef,
    # userids => [],
    # sendnotificationwhendown => true,
    # notifyagainevery => undef,
    # notifywhenbackup => false,
    # tags => [],
    # probe_filters => [],
    # ipv6 => false,
    # responsetime_threshold => undef,
    # integrationids => [],
    # teamids => []
}
```
