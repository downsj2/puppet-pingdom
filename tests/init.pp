Pingdom_check {
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey
}

pingdom_check { "http://${facts['fqdn']}/check":
    ensure                   => present,
    provider                 => 'http',
    host                     => $facts['fqdn'],
    url                      => '/check',
    paused                   => true,
    resolution               => 5,
    ipv6                     => false,
    sendnotificationwhendown => 2,
    notifyagainevery         => 0,
    notifywhenbackup         => false
    tags                     => ['test', 'web']
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    hostname         => "ping://${facts['fqdn']}",
    expectedip       => '1.2.3.4',
    nameserver       => '8.8.8.8',
    paused           => true,
    notifywhenbackup => false
    tags             => ['test', 'dns']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => ${facts['fqdn']},
    paused           => true,
    notifywhenbackup => false,
    tags             => ['test', 'ping']
}
