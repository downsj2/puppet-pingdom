# puppet-pingdom <img align="right" src="https://my.pingdom.com/images/pingdom.svg" />
Puppet type and provider for the Pingdom API. 

#### Status
Currently supports the 2.0 API with legacy notifications. 

This module is considered fully-functional, but hasn't seen wide testing. Please consider helping by submitting [bug reports](https://github.com/cwells/puppet-pingdom/issues). Pull requests also welcome.

#### Types
[`pingdom_check`][pingdom_check_properties], [`pingdom_contact`][pingdom_contact_properties]

#### Check providers
`dns`, `http`, `httpcustom`, `imap`, `ping`, `pop3`, `smtp`, `tcp`, `udp`

---
#### Example usage
###### Defaults:
```puppet
Pingdom_check {
    username      => $pingdom_username,
    password      => $pingdom_password,
    appkey        => $pingdom_appkey,
    probe_filters => ['NA'],
    contacts => [ 
        'DevOps',
        'DevOps Pager'
    ],
    paused        => true
}

Pingdom_contact {
    username    => $pingdom_username,
    password    => $pingdom_password,
    appkey      => $pingdom_appkey,
    countrycode => '1',
    countryiso  => 'US'
}
```

###### Contacts:
```puppet
pingdom_contact { 'DevOps':
    ensure    => present,
    email     => 'devops@company.com',
    cellphone => '555-222-4444'
}

pingdom_contact { 'DevOps Pager':
    ensure    => present,
    email     => 'devops-pager@company.com',
    cellphone => '555-222-3333'
}
```

###### HTTP check:
```puppet
pingdom_check { "http://${facts['fqdn']}/check":
    ensure         => present,
    provider       => 'http',
    host           => $facts['fqdn'],
    url            => '/check',
    auth           => "admin:p@ssw0rd",
    requestheaders => {
        'Accept' => 'x-application/json'
    },
    postdata => {
        'api_key'  => 'abcdef1234567890abcdef1234567890',
        'api_user' => 'automation'
    },
    resolution     => 5,
    tags           => ['http', 'puppet-managed']
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
    tags       => ['dns', 'puppet-managed']
}
```

###### Ping check:
```puppet
pingdom_check { "ping://${facts['fqdn']}":
    ensure   => present,
    provider => 'ping',
    host     => $facts['fqdn'],
    tags     => ['ping', 'puppet-managed']
}
```

#### Installation
See instructions on [PuppetForge](https://forge.puppet.com/cwells/pingdom/readme).

#### Known issues
- `puppet resource pingdom_check` command will likely never work, since `self.instances` is a class method and doesn't have access to instantiation-time parameters such as credentials.
- BeepManager API isn't currently manageable. That's an API 2.1 feature and 2.1 isn't publicly available yet. This means only legacy notifications are supported. Sucks, but the silver lining is that you don't _have_ to manage notifications with Puppet. Unless otherwise specified, BeepManager is the default, so you can simply skip controlling this aspect with Puppet and let the defaults handle the situation.

[pingdom_check_properties]: https://github.com/cwells/puppet-pingdom/wiki/Check-properties
[pingdom_contact_properties]: https://github.com/cwells/puppet-pingdom/wiki/Contact-properties
