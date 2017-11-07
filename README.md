# puppet-pingdom <img align="right" src="https://my.pingdom.com/images/pingdom.svg" />
Puppet type and provider for Pingdom API.

#### Status
> Currently supports API 2.0 with legacy notifications. This means no BeepManager support yet, since that's a 2.1 feature.
> 
> Still a work-in-progress (property coverage is probably not 100% at the moment), but the basics are fully functional. Please provide [bug reports](https://github.com/cwells/puppet-pingdom/issues)!
> 
#### Providers
**http** <sup>[1]</sup>, **ping** <sup>[1]</sup>, **dns** <sup>[1]</sup>, **imap** <sup>[2]</sup>, **pop3** <sup>[2]</sup>, **smtp** <sup>[2]</sup>, **tcp** <sup>[2]</sup>, **udp** <sup>[2]</sup>, **httpcustom** <sup>[2]</sup>

> <sup>[1]</sup> tested, considered fully functional.
> <sup>[2]</sup> untested, but _should_ work.
> <sup>[3]</sup> untested, and probably incomplete.

###### Credentials:
```puppet
Pingdom_check {
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey
}
```
###### HTTP check:
```puppet
pingdom_check { "http://${facts['fqdn']}/check":
    ensure     => present,
    provider   => 'http',
    host       => $facts['fqdn'],
    url        => '/check',
    paused     => true,
    resolution => 5,
    contacts   => ['devops@company.com', 'devops-pager@company.com'],
    tags       => ['http', $facts['fqdn'], 'puppet-managed']
}
```
###### DNS check:
```puppet
pingdom_check { "dns://${facts['fqdn']}":
    ensure     => present,
    provider   => 'dns',
    host       => $facts['fqdn'],
    expectedip => '1.2.3.4',
    nameserver => '8.8.8.8',
    paused     => true,
    tags       => ['dns', $facts['fqdn'], 'puppet-managed']
}
```
###### Ping check:
```puppet
pingdom_check { "ping://${facts['fqdn']}":
    ensure        => present,
    provider      => 'ping',
    host          => $facts['fqdn'],
    paused        => true,
    probe_filters => ['NA', 'EU', 'APAC'],
    tags          => ['ping', $facts['fqdn'], 'puppet-managed']
}
```
#### Installation
See [instructions on PuppetForge](https://forge.puppet.com/cwells/pingdom/readme)

#### Known issues
- `puppet resource pingdom_check` command will likely never work, since `self.instances` is a class method and doesn't have access to instantiation-time parameters such as credentials.
- BeepManager API isn't currently manageable. That's an API 2.1 feature and 2.1 isn't publicly available yet. This means only legacy notifications are supported. Sucks, but the silver lining is that you don't _have_ to manage notifications with Puppet. Unless otherwise specified, BeepManager is the default, so you can simply skip controlling this aspect with Puppet and let the defaults handle the situation.
- There's no published API endpoints for managing contacts. This means that contacts specified in the check must pre-exist in Pingdom, otherwise the resource will fail.

