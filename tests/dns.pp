pingdom_check { "ping://puppet.aws.focusvision.com":
    ensure   => present,
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey,

    # provider-specific properties
    provider   => 'dns',
    hostname   => 'www.company.com',
    expectedip => '1.2.3.4',
    nameserver => '8.8.8.8',

    # common properties
    paused => true,
    tags   => ['test', 'dns'],
}
