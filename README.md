# puppet-pingdom <img align="right" src="https://my.pingdom.com/images/pingdom.svg" />
Puppet type and provider for the Pingdom API.

#### Status
Currently supports the Pingdom v2.1 API.

As of [0.7.0](https://github.com/cwells/puppet-pingdom/releases/tag/0.7.0), this module no longer depends on the 3rd-party `faraday` gem. This should simplify installation.

Please consider helping by submitting [bug reports](https://github.com/cwells/puppet-pingdom/issues). Pull requests also welcome.

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
    account_email => Sensitive($pingdom_account_email),
    user_email    => Sensitive($pingdom_user_email),
    password      => Sensitive($pingdom_password),
    appkey        => $pingdom_appkey
}

Pingdom_check {
    account_email => Sensitive($pingdom_account_email),
    user_email    => Sensitive($pingdom_user_email),
    password      => Sensitive($pingdom_password),
    appkey        => $pingdom_appkey,
    probe_filters => ['NA'],
    contacts      => ['DevOps', 'DevOps Pager']
}
```

###### Contacts:
```puppet
pingdom_user { 'DevOps':
    ensure          => present,
    contact_targets => [
        { email  => 'devops@domain.com' },
        { number => '555-123-1212', countrycode => '1' }
    ]
}

pingdom_user { 'DevOps Pager':
    ensure          => present,
    contact_targets => [
        { email  => 'devops-pager@domain.com' },
        { number => '555-123-1213', countrycode => '1' }
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

###### Hiera:

```yaml
pingdom::account_email: 'support@company.com'
pingdom::user_email: 'puppet@company.com'
pingdom::password: ENC[PKCS7,EYAMLENCODEDPASSWORD]
pingdom::appkey: '1348934113454334'

pingdom::users:
  'DevOps':
    contact_targets:
    - email: devops@company.com
    - number: 555-123-1234
      countrycode: 1

  'DevOps Pager':
    contact_targets:
    - number: 555-123-3214
      countrycode: 1

pingdom::checks:
  "http://%{facts.fqdn}/status":
    provider: http
    host: "%{facts.fqdn}"
    url: /status
    contacts:
    - DevOps
    - DevOps Pager
    tags:
    - http

  "ping://%{facts.fqdn}":
    provider: ping
    host: "%{facts.fqdn}"
    contacts:
    - DevOps
    - DevOps Pager
    tags:
    - ping
```

After configuring Hiera, simply `include pingdom` in your manifest:

```puppet
class myclass {
    include pingdom
}
```

---

#### Installation
See instructions on [PuppetForge](https://forge.puppet.com/cwells/pingdom/readme).

---

#### Attention
This module utilizes a feature named `autofilter` [default: `true`]. Be aware that this feature will automatically tag your checks with a shortened SHA1 hash of the check's `name` property, and automatically set `filter_tags` to include this tag. This allows us to efficiently locate this check in the future. However, if you have existing checks, enabling `autofilter` will cause them to no longer be found (since they lack the requisite SHA1 tag in `filter_tags`).

To get around this, and have your existing checks tagged, set `autofilter => 'bootstrap'` and run Puppet on all your nodes. This will enable tagging, but not set `filter_tags`. If you have a lot of existing checks, this may be a slow Puppet run. Once the run has completed, set `autofilter => true` or simply remove the parameter altogether.

---

#### Known issues
- `puppet resource pingdom_check` command will likely never work, since `self.instances` is a class method and doesn't have access to instantiation-time parameters such as credentials.
- Users API is incomplete (can only manage contacts, not admins).
- Teams API is unimplemented.

[pingdom_check_properties]: https://github.com/cwells/puppet-pingdom/wiki/Check-properties
[pingdom_user_properties]: https://github.com/cwells/puppet-pingdom/wiki/User-properties
