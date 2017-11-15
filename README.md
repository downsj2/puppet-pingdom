# puppet-pingdom <img align="right" src="https://my.pingdom.com/images/pingdom.svg" />
Puppet type and provider for the Pingdom API.

#### Status
Currently supports the 2.1 API (if you need 2.0 API support, checkout the 0.5 releases, but be aware that Pingdom is ending 2.0 API support within the year).

This module is considered fully-functional, but hasn't seen wide testing. Please consider helping by submitting [bug reports](https://github.com/cwells/puppet-pingdom/issues). Pull requests also welcome.

---

#### Types
[`pingdom_check`][pingdom_check_properties] [`pingdom_user`][pingdom_user_properties]

#### Check providers
`dns` `http` `httpcustom` `imap` `ping` `pop3` `smtp` `tcp` `udp`

---

#### Example usage
###### Defaults:
```puppet
Pingdom_user {
    username => Sensitive($pingdom_username),
    password => Sensitive($pingdom_password),
    appkey   => $pingdom_appkey,
    paused   => true
}

Pingdom_check {
    username      => Sensitive($pingdom_username),
    password      => Sensitive($pingdom_password),
    appkey        => $pingdom_appkey,
    probe_filters => ['NA'],
    contacts      => ['DevOps', 'DevOps Pager'],
    paused        => true
}
```

###### Contacts:
```puppet
pingdom_user { 'DevOps':
    ensure          => present,
    contact_targets => [
        { email  => 'devops@domain.com', severity => 'HIGH' },
        { number => '555-123-1212', countrycode => '1', severity => 'HIGH' }
    ]
}

pingdom_user { 'DevOps Pager':
    ensure          => present,
    contact_targets => [
        { email  => 'devops-pager@domain.com', severity => 'HIGH' },
        { number => '555-123-1213', countrycode => '1', severity => 'HIGH' }
    ]
}
```

###### HTTP check:
```puppet
pingdom_check { "http://${facts['fqdn']}/check":
    ensure         => present,
    provider       => 'http',
    host           => $facts['fqdn'],
    url            => '/check',
    auth           => Sensitive("admin:p@ssw0rd"),
    requestheaders => {
        'Accept' => 'x-application/json'
    },
    postdata => Sensitive({
        'api_key'  => 'abcdef1234567890abcdef1234567890',
        'api_user' => 'automation'
    }),
    resolution     => 5,
    tags           => ['http']
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
    tags       => ['dns']
}
```

###### Ping check:
```puppet
pingdom_check { "ping://${facts['fqdn']}":
    ensure   => present,
    provider => 'ping',
    host     => $facts['fqdn'],
    tags     => ['ping']
}
```

---

#### Installation
See instructions on [PuppetForge](https://forge.puppet.com/cwells/pingdom/readme).

---

#### Attention
This module utilizes a feature named `autofilter` [default: `true`]. Be aware that this feature will automatically tag your checks with a shortened SHA1 hash of the check's `name` property, and automatically set `filter_tags` to include this tag. This allows us to efficiently locate this check in the future. However, if you have existing checks, enabling `autofilter` will cause them to no longer be found (since they lack the requisite SHA1 tag in `filter_tags`).

To get around this, and have your existing checks tagged, set `autofilter => 'bootstrap'` and run Puppet on all your nodes. This will enable tagging, but not set `filter_tags`. If you have a lot of existing checks, this may be a slow Puppet run.

---

#### Known issues
- `puppet resource pingdom_check` command will likely never work, since `self.instances` is a class method and doesn't have access to instantiation-time parameters such as credentials.
- BeepManager API isn't currently manageable. That's an API 2.1 feature and 2.1 support is under development. This means only legacy notifications are supported. Sucks, but the silver lining is that you don't _have_ to manage notifications with Puppet. Unless otherwise specified, BeepManager is the default, so you can simply skip controlling this aspect with Puppet and let the defaults handle the situation.

[pingdom_check_properties]: https://github.com/cwells/puppet-pingdom/wiki/Check-properties
[pingdom_user_properties]: https://github.com/cwells/puppet-pingdom/wiki/User-properties
