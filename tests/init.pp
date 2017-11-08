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
    postdata         => {
        username => 'admin',
        password => 'p@ssw0rd'
    },
    requestheaders   => {
        'Content-Type' => 'x-application/json',
        'Auth-Token'   => 'XXX892N123456'
    },
    shouldcontain    => 'healthy',
    resolution       => 5,
    paused           => true,
    ipv6             => false,
    notifyagainevery => 0,
    notifywhenbackup => false,
    tags             => ['http', 'puppet-managed'],
    contacts         => [
        'devops@company.com',
        'devops-pager@company.com'
    ]
}

pingdom_check { "httpcustom://${facts['fqdn']}/status/pingdom.xml":
    ensure           => present,
    provider         => 'httpcustom',
    host             => $facts['fqdn'],
    url              => '/status/pingdom.xml',
    auth             => 'super:secret',
    additionalurls   => [
        'http://www.domain1.com',
        'http://www.domain2.com'
    ],
    paused           => true,
    tags             => ['http', 'puppet-managed'],
    logging          => 'INFO'
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    host             => $facts['fqdn'],
    expectedip       => '1.2.3.4',
    nameserver       => '8.8.8.8',
    paused           => true,
    notifywhenbackup => false,
    contacts         => ['operations@company.com'],
    tags             => ['dns', 'puppet-managed']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => $facts['fqdn'],
    paused           => true,
    notifywhenbackup => false,
    tags             => ['ping', 'puppet-managed']
}

pingdom_check { "imap://${facts['fqdn']}":
    ensure         => present,
    provider       => 'imap',
    host           => $facts['fqdn'],
    port           => 993,
    stringtoexpect => 'Courier IMAP',
    encryption     => true,
    paused         => true,
    tags           => ['imap', 'puppet-managed']
}

pingdom_check { "pop3://${facts['fqdn']}":
    ensure         => present,
    provider       => 'pop3',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Courier POP3',
    encryption     => true,
    paused         => true,
    tags           => ['pop3', 'puppet-managed']
}

pingdom_check { "smtp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'smtp',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Postfix',
    encryption     => true,
    paused         => true,
    tags           => ['smtp', 'puppet-managed']
}

pingdom_check { "tcp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'tcp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'ping',
    stringtoexpect => 'pong',
    encryption     => true,
    paused         => true,
    tags           => ['tcp', 'puppet-managed']
}

pingdom_check { "udp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'udp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'ping',
    stringtoexpect => 'pong',
    encryption     => true,
    paused         => true,
    tags           => ['udp', 'puppet-managed']
}
