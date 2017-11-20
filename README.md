# puppet-pingdom <img align="right" src="https://my.pingdom.com/images/pingdom.svg" />
Puppet type and provider for the Pingdom API.

#### Status
Currently supports the [Pingdom 2.1 API](http://www.pingdom.com/resources/api/2.1).

This module has no external dependencies, and should be widely-compatible and simple to install.

Please consider helping by submitting [bug reports](https://github.com/cwells/puppet-pingdom/issues). Pull requests also welcome.

#### Warning
<img align="left" src="https://image.flaticon.com/icons/svg/159/159469.svg" width="50" height="50" />

[0.9.0](https://github.com/cwells/puppet-pingdom/releases/tag/0.9.0) introduces a breaking change. `Pingdom_check.contacts` has been renamed to `Pingdom_check.users` to be consistent with naming conventions.

---

#### Types
[`pingdom_check`][pingdom_check_properties] [`pingdom_user`][pingdom_user_properties] [`pingdom_team`][pingdom_team_properties] <sup>[1]</sup> [`pingdom_settings`][pingdom_settings_properties]

<sup>[1]</sup> Multi-user accounts only.

#### Check providers
`dns` `http` `httpcustom` `imap` `ping` `pop3` `smtp` `tcp` `udp`

---

#### Example usage
###### Defaults:
```puppet
Pingdom_team {
    account_email => Sensitive($pingdom_account_email),
    user_email    => Sensitive($pingdom_user_email),
    password      => Sensitive($pingdom_password),
    appkey        => $pingdom_appkey
}

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
    probe_filters => ['NA']
}
```

###### Contacts:
```puppet
pingdom_user { 'Steve Smith':
    ensure          => present,
    contact_targets => [
        { email  => 'ssmith@domain.com' },
        { number => '555-123-1212', countrycode => '1' }
    ]
}

pingdom_user { 'DevOps Pager':
    ensure          => present,
    contact_targets => [
        { number => '555-123-1213', countrycode => '1' }
    ]
}
```

###### Teams:
```puppet
pingdom_team { 'DevOps':
    ensure => present,
    users  => [
        'Steve Smith',
        'DevOps Pager'
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
    resolution     => 5,
    requestheaders => {
        'Accept' => 'x-application/json'
    },
    postdata => Sensitive({
        'api_key'  => 'abcdef1234567890abcdef1234567890',
        'api_user' => 'automation'
    }),
    teams          => ['DevOps'],
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
    users      => ['DevOps Pager'],
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

###### Settings:
```puppet
pingdom_settings { 'Pingdom Settings':
    firstname   => 'Brad',
    lastname    => 'Brown',
    company     => 'Company, Inc.',
    email       => 'bbrown@company.com',
    cellphone   => '555-123-3333',
    description => 'This account is managed by Puppet.'
}
```

###### Hiera:

```yaml
pingdom::account_email: support@company.com
pingdom::user_email: puppet@company.com
pingdom::password: ENC[PKCS7,EYAMLENCODEDPASSWORD]
pingdom::appkey: ABCDEF1234567890FEDCBA

pingdom::settings:
  'Pingdom Settings':
    firstname: Brad
    lastname: Brown
    company: Company, Inc.
    email: bbrown@company.com
    cellphone: 555-123-3333
    description: This account is managed by Puppet.

pingdom::users:
  'Steve Smith':
    contact_targets:
    - email: devops@company.com
    - number: 555-123-1234
      countrycode: 1

  'DevOps Pager':
    contact_targets:
    - number: 555-123-3214
      countrycode: 1

pingdom::teams:
  'DevOps':
    users:
    - Steve Smith
    - DevOps Pager

pingdom::checks:
  "http://%{facts.fqdn}/status":
    provider: http
    host: "%{facts.fqdn}"
    url: /status
    teams:
    - DevOps
    tags:
    - http

  "ping://%{facts.fqdn}":
    provider: ping
    host: "%{facts.fqdn}"
    users:
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
- There's a difference in login requirements for _Starter_ and _Standard_ plans (specifically, these two levels lack multi-user login). I'm currently only able to test against _Enterprise_. If you have a _Starter_ or _Standard_ plan and have issues authenticating to Pingdom, reach out to me and we can get it working.
- The Integrations API isn't documented, so we can't manage integrations yet.

[pingdom_check_properties]: https://github.com/cwells/puppet-pingdom/wiki/Check-properties
[pingdom_user_properties]: https://github.com/cwells/puppet-pingdom/wiki/User-properties
[pingdom_team_properties]: https://github.com/cwells/puppet-pingdom/wiki/Team-properties
[pingdom_settings_properties]: https://github.com/cwells/puppet-pingdom/wiki/Settings-properties
