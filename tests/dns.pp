pingdom_check { 'cliff dns test':
    ensure   => present,
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',

    # provider-specific properties
    provider   => 'dns',
    hostname   => 'puppet.aws.focusvision.com',
    expectedip => '52.14.202.244',
    nameserver => '8.8.8.8',

    # common properties
    paused => true,
    tags   => ['sre', 'test', 'dns'],
}
