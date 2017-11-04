pingdom_check { "http://${facts['fqdn']}/check":
    ensure   => present,
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey,

    # provider-specific properties
    provider => 'http',
    host     => $facts['fqdn'],
    url      => '/check',

    # common properties
    paused                   => true,
    resolution               => 5,
    ipv6                     => false,
    tags                     => ['test', 'web'],
    sendnotificationwhendown => 2,
    notifyagainevery         => 0,
    notifywhenbackup         => false,

    # *not implemented yet*
    # userids => [],
    # probe_filters => [],
    # integrationids => [],
    # teamids  => [],
}
