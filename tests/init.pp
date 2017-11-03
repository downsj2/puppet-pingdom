pingdom { $facts['hostname']:
    ensure   => absent,
    provider => 'http',
    username => '<your pingdom username>',
    password => '<your pingdom password>',
    appkey   => '<your pingdom appkey>',
    paused   => true,

    params => {
        host => $facts['hostname'],
        url  => '/survey/demo/dashboard',
    }

    # resolution => undef,
    # userids => [],
    # sendnotificationwhendown => true,
    # notifyagainevery => undef,
    # notifywhenbackup => false,
    # tags => [],
    # probe_filters => [],
    # ipv6 => false,
    # responsetime_threshold => undef,
    # integrationids => [],
    # teamids => []
}
