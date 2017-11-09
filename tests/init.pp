# Before running the tests, create a file named
# ~/.pingdom_credentials with the following YAML content:
#
#     ---
#     username: 'Your Pingdom username'
#     password: 'Your Pingdom password'
#     appkey: 'Your Pingdom appkey'
#
# Alternatively, just provide your credentials in the
# resource declarations below. Just be sure not to commit
# them to git ;-)
#
# At this point, from the top-level directory, you can run:
#     `export RUBYLIB=$PWD/lib ; puppet apply tests/init.pp`

Pingdom_check {
    credentials_file => '~/.pingdom_credentials',
    paused           => true,
    contacts => [
        'DevOps',
        'DevOps Pager'
    ]
}

Pingdom_contact {
    credentials_file => '~/.pingdom_credentials',
    countrycode      => '1',
    countryiso       => 'US'
}

pingdom_contact { 'DevOps':
    ensure    => present,
    email     => 'devops@company.com',
    cellphone => '555-222-4444'
}

pingdom_contact { 'DevOps Pager':
    ensure    => present,
    email     => 'devops-pager@company.com',
    cellphone => '555-222-3333'
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
    ipv6             => false,
    notifyagainevery => 0,
    notifywhenbackup => false,
    tags             => ['http', 'puppet-managed']
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
    tags             => ['http', 'puppet-managed']
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    host             => $facts['fqdn'],
    expectedip       => '1.2.3.4',
    nameserver       => '8.8.8.8',
    notifywhenbackup => false,
    tags             => ['dns', 'puppet-managed']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => $facts['fqdn'],
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
    tags           => ['udp', 'puppet-managed']
}
