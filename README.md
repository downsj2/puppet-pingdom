## puppet-pingdom
Puppet type and provider for Pingdom API

### Status
- Check CRUD
  - create works
  - delete works
  - update works partially
      - tags attribute works
      - other attributes TBD     
- Team CRUD TBD
- User CRUD TBD

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
