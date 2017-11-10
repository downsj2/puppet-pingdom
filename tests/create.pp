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
#     `export RUBYLIB=$PWD/lib ; puppet apply tests/create.pp`

Pingdom_contact {
    credentials_file   => '~/.pingdom_credentials',
    countrycode        => '1',
    countryiso         => 'US',
    defaultsmsprovider => 'esendex',
    directtwitter      => true,
    twitteruser        => 'kimjongil'
}

Pingdom_check {
    credentials_file         => '~/.pingdom_credentials',
    paused                   => true,
    ipv6                     => false,
    notifyagainevery         => 0,
    notifywhenbackup         => false,
    resolution               => 30,
    sendnotificationwhendown => 3,
    contacts                 => [
        'DevOps',
        'DevOps Pager'
    ],
    tags                     => ['puppet-managed'],
    autofilter               => true
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
    postdata         => Sensitive({
        username => 'admin',
        password => 'p@ssw0rd'
    }),
    requestheaders   => Sensitive({
        'Content-Type' => 'x-application/json',
        'Auth-Token'   => 'XXX892N123456'
    }),
    shouldcontain    => 'healthy',
    port             => 80,
    auth             => "admin:password",
    encryption       => false,
    tags             => ['http']
}

pingdom_check { "httpcustom://${facts['fqdn']}/status/pingdom.xml":
    ensure           => present,
    provider         => 'httpcustom',
    host             => $facts['fqdn'],
    url              => '/status/pingdom.xml',
    auth             => Sensitive('super:secret'),
    additionalurls   => [
        'http://www.domain1.com',
        'http://www.domain2.com'
    ],
    port             => 80,
    encryption       => true,
    tags             => ['http']
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    host             => $facts['fqdn'],
    expectedip       => '1.2.3.4',
    nameserver       => '8.8.8.8',
    notifywhenbackup => false,
    tags             => ['dns']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => $facts['fqdn'],
    notifywhenbackup => false,
    tags             => ['ping']
}

pingdom_check { "imap://${facts['fqdn']}":
    ensure         => present,
    provider       => 'imap',
    host           => $facts['fqdn'],
    port           => 993,
    stringtoexpect => 'Courier IMAP',
    encryption     => true,
    tags           => ['imap']
}

pingdom_check { "pop3://${facts['fqdn']}":
    ensure         => present,
    provider       => 'pop3',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Courier POP3',
    encryption     => true,
    paused         => true,
    tags           => ['pop3']
}

pingdom_check { "smtp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'smtp',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Postfix',
    encryption     => true,
    tags           => ['smtp']
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
    tags           => ['tcp']
}

pingdom_check { "udp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'udp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'ping',
    stringtoexpect => 'pong',
    encryption     => true,
    tags           => ['udp']
}

