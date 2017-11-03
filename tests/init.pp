pingdom_check { "http://${facts['fqdn']}/check":
    ensure   => present,
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',

    # provider-specific properties
    provider => 'http',
    host     => $facts['fqdn'],
    url      => '/check',

    # common properties
    paused                   => true,
    resolution               => 5,
    ipv6                     => false,
    tags                     => ['sre', 'test', 'web'],
    sendnotificationwhendown => 2,
    notifyagainevery         => 0,
    notifywhenbackup         => false,

    # *not implemented yet*
    # userids => [],
    # probe_filters => [],
    # integrationids => [],
    # teamids  => [],
}

