Pingdom_check {
    username => $pingdom_username,
    password => $pingdom_password,
    appkey   => $pingdom_appkey
}

pingdom_check { "http://${facts['fqdn']}/check":
    ensure           => present,
    provider         => 'http',
    host             => $facts['fqdn'],
    url              => '/check',
    resolution       => 5,
    paused           => true,
    ipv6             => false,
    notifyagainevery => 0,
    notifywhenbackup => false,
    tags             => ['http', $facts['fqdn'], 'puppet-managed'],
    contacts         => ['devops@company.com', 'devops_pager@company.com']
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    host             => $facts['fqdn'],
    expectedip       => '1.2.3.4',
    nameserver       => '8.8.8.8',
    paused           => true,
    notifywhenbackup => false,
    tags             => ['dns', $facts['fqdn'], 'puppet-managed']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => $facts['fqdn'],
    paused           => true,
    notifywhenbackup => false,
    tags             => ['ping', $facts['fqdn'], 'puppet-managed']
}
