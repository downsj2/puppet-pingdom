# puppet-pingdom
Puppet type and provider for Pingdom API 

## Status
Currently supports API 2.0 with legacy notifications. This means no BeepManager support yet, since that's a 2.1 feature. 

Still a work-in-progress (property coverage is probably not 100% at the moment), but the basics are fully functional.

#### Credentials:
```puppet
Pingdom_check {
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey
}
```
#### HTTP check:
```puppet
pingdom_check { "http://${facts['fqdn']}/check":
    ensure     => present,
    provider   => 'http',
    host       => $facts['fqdn'],
    url        => '/check',
    paused     => true,
    resolution => 5,
    tags       => ['test', 'http']
}
```
#### DNS check:
```puppet
pingdom_check { 'dns://hq.company.com':
    ensure     => present,
    provider   => 'dns',
    hostname   => 'hq.company.com',
    expectedip => '1.2.3.4',
    nameserver => '8.8.8.8',
    paused     => true,
    tags       => ['test', 'dns']
}
```
#### Ping check:
```puppet
pingdom_check { 'ping://www.google.com':
    ensure        => present,
    provider      => 'ping',
    host          => 'www.google.com',
    paused        => true,
    probe_filters => ['NA', 'EU', 'APAC'],
    tags          => ['test', 'ping']
}
```

### Known issues
- `puppet resource pingdom_check` command will likely never work, as it's not possible to collect authenticated resources inside of `self.instances`, since it's a class method and doesn't have access to instantiation-time parameters such as credentials.
- BeepManager API isn't available. That's an API 2.1 feature and 2.1 isn't publicly available yet. This means only legacy notifications are supported. Sucks, but the silver lining is that you don't _have_ to manage notifications with Puppet. Unless otherwise specified, BeepManager is the default, so you can simply skip controlling this aspect with Puppet and let the defaults handle the situation.
  
