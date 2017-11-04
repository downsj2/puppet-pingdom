## puppet-pingdom
Puppet type and provider for Pingdom API

### Status
- Check CRUD
  - create works
  - delete works
  - update works 
  - properties work partially
      - scalar properties work
      - structured tags properties works
      - other structured properties TBD
- Team CRUD TBD
- User CRUD TBD

```puppet
pingdom_check { "http://${facts['fqdn']}/check":
    ensure   => present,
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',
    
    # provider-specific properties
    provider => 'http',
    host     => $facts['fqdn'],
    url      => '/check',

    # common properties
    paused                   => true,
    tags                     => [ 'web', 'sales' ],
    resolution               => 5,
    ipv6                     => false,
    sendnotificationwhendown => 2,
    notifyagainevery         => 0,
    notifywhenbackup         => false,
}
```
### Known issues
- `puppet resource pingdom_check` command will likely never work, as it's not possible to collect authenticated resources inside of `self.instances`, since it's a class method and doesn't have access to instantiation-time parameters such as credentials.
- Pingdom API doesn't seem to respect setting `notifywhenbackup`.
  
