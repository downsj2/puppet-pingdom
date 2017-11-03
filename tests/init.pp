pingdom_check { "http://${facts['hostname']}/check":
    ensure   => present,
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',

    # provider-specific properties
    provider => 'http',
    host     => $facts['hostname'],
    url      => '/check',

    # common properties
    paused                   => true,
    resolution               => 5,
    sendnotificationwhendown => true,
    notifywhenbackup         => false,
    ipv6                     => false,
    notifyagainevery         => 0,
    responsetime_threshold   => 30000,

    # *not implemented yet*
    # userids => [],
    # probe_filters => [],
    # integrationids => [],
    # teamids  => [],
    # tags     => []
}

