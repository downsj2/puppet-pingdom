## puppet-pingdom
Puppet type and provider for Pingdom API

### Status
- Check CRUD
  - create works
  - delete works
  - update works partially
      - tags attribute works
      - paused attribute works
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
### Known issues
- `puppet resource pingdom_check` command will likely never work, as it's not possible to collect authenticated resources inside of `self.instances`, since it's a class method and doesn't have access to instantiation-time parameters.
- Pingdom API doesn't return the following documented properties, which leads me to believe they are no longer valid
  - sendnotificationwhendown
  
