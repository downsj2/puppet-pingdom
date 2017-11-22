# Before running the tests, create a file named
# ~/.pingdom_credentials with the following YAML content:
#
#     ---
#     account_email: 'Pingdom account Owner email address'
#     user_email: 'Your Pingdom email address'
#     password: 'Your Pingdom password'
#     appkey: 'Your Pingdom appkey'
#
# Alternatively, just provide your credentials in the
# resource declarations below. Just be sure not to commit
# them to git ;-)
#
# At this point, from the top-level directory, you can run:
#     `export RUBYLIB=$PWD/lib ; puppet apply tests/create.pp`

Pingdom_user {
    credentials_file => '~/.pingdom_credentials',
    paused           => true
}

Pingdom_team {
    credentials_file => '~/.pingdom_credentials'
}

Pingdom_check {
    credentials_file       => '~/.pingdom_credentials',
    paused                 => true,
    ipv6                   => false,
    resolution             => 30,
    notifyagainevery       => 5,
    notifywhenbackup       => false,
    responsetime_threshold => 10,
    probe_filters          => ['NA', 'APAC'],
    users                  => [ 'SRE PagerDuty' ]
}

pingdom_settings { 'Pingdom Settings':
    credentials_file => '~/.pingdom_credentials',
    company          => 'Company, Inc.'
}

pingdom_user { 'SRE PagerDuty':
    ensure          => present,
    contact_targets => [
        { email  => 'pagerduty@domain.com' },
        { number => '555-123-1212', countrycode => '1', provider => 'BULKSMS' }
    ]
}

pingdom_team { 'SRE':
    ensure => present,
    users  => ['SRE PagerDuty']
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
    tags             => ['http'],
    teams            => ['SRE']
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
    tags             => ['dns']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => $facts['fqdn'],
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

