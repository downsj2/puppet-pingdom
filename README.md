# puppet-pingdom <img align="right" src="https://my.pingdom.com/images/pingdom.svg" />
Puppet type and provider for the Pingdom API.

#### Status
Currently supports API 2.0 with legacy notifications. This means no BeepManager support yet, since that's a 2.1 feature.
 
Still a work-in-progress (property coverage is probably not 100% at the moment), but the basics are fully functional. Please provide [bug reports](https://github.com/cwells/puppet-pingdom/issues)!
 
#### Providers
**http**, **ping**, **dns**, **imap**, **pop3**, **smtp**, **tcp**, **udp**, **httpcustom**

Please see the [wiki](https://github.com/cwells/puppet-pingdom/wiki/Provider-properties) for provider properties and links to other resources.

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
    ensure         => present,
    provider       => 'http',
    host           => $facts['fqdn'],
    url            => '/check',
    auth           => "admin:p@ssw0rd",
    requestheaders => {
        'Content-Type' => 'x-application/json'
    },
    postdata       => {
        'api_key'  => 'abcdef1234567890abcdef1234567890',
        'api_user' => 'automation'
    },
    paused         => true,
    resolution     => 5,
    contacts       => ['devops@company.com', 'devops-pager@company.com'],
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
    paused     => true,
    tags       => ['dns', 'puppet-managed']
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
    tags          => ['ping', 'puppet-managed']
}
```
#### Installation
See instructions on [PuppetForge](https://forge.puppet.com/cwells/pingdom/readme).

#### Known issues
- `puppet resource pingdom_check` command will likely never work, since `self.instances` is a class method and doesn't have access to instantiation-time parameters such as credentials.
- BeepManager API isn't currently manageable. That's an API 2.1 feature and 2.1 isn't publicly available yet. This means only legacy notifications are supported. Sucks, but the silver lining is that you don't _have_ to manage notifications with Puppet. Unless otherwise specified, BeepManager is the default, so you can simply skip controlling this aspect with Puppet and let the defaults handle the situation.
- The Contacts API is incomplete. This means that contacts specified in the check must currently pre-exist in Pingdom, otherwise the resource will fail.

