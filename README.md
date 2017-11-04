## puppet-pingdom
Puppet type and provider for Pingdom API. 

Still a work-in-progress, as most of the providers aside from HTTP and DNS haven't been tested at all, and even those don't support the entire API at this point.

### Status
- Check API
  - create works
  - delete works
  - update works 
  - properties work partially
      - scalar properties work
      - structured tags properties works
      - other structured properties TBD
- Team API TBD
- User API TBD

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

pingdom_check { 'ping://hq.company.com':
    ensure   => present,
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',
    
    # provider-specific properties
    provider   => 'dns',
    hostname   => 'hq.company.com',
    expectedip => '1.2.3.4',
    nameserver => '8.8.8.8',

    # common properties
    paused => true,
    tags   => ['sre', 'test', 'dns'],
}
```
### Known issues
- `puppet resource pingdom_check` command will likely never work, as it's not possible to collect authenticated resources inside of `self.instances`, since it's a class method and doesn't have access to instantiation-time parameters such as credentials.
- Pingdom API doesn't seem to respect setting `notifywhenbackup`.
  
