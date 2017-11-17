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
#     `export RUBYLIB=$PWD/lib ; puppet apply tests/update.pp`

Pingdom_user {
    credentials_file => '~/.pingdom_credentials',
    paused           => true
}

Pingdom_team {
    credentials_file => '~/.pingdom_credentials'
}

Pingdom_check {
    credentials_file => '~/.pingdom_credentials',
    paused           => true,
    ipv6             => false,
    resolution       => 30,
    contacts         => [
        'DevOps',
        'DevOps Pager'
    ]
}

pingdom_user { 'DevOps':
    ensure          => present,
    contact_targets => [
        { email  => 'devops@domain.com', severity => 'HIGH' },
        { number => '555-123-1212', countrycode => '1', severity => 'HIGH' }
    ]
}

pingdom_user { 'DevOps Pager':
    ensure          => present,
    contact_targets => [
        { email  => 'devops-pager@domain.com', severity => 'HIGH' },
        { number => '555-123-1234', countrycode => '1', severity => 'HIGH' }
    ]
}

pingdom_team { 'SRE':
    ensure => present,
    users => [
        'SRE PagerDuty',
        'DevOps',
        'DevOps Pager'
    ]
}

pingdom_user { 'SRE PagerDuty':
    ensure          => present,
    contact_targets => [
        { email  => 'pager@domain.com' },
        { number => '555-321-4321', countrycode => '1' }
    ]
}

pingdom_check { "http://${facts['fqdn']}/check":
    ensure           => present,
    provider         => 'http',
    host             => $facts['fqdn'],
    url              => '/check',
    postdata         => Sensitive({
        username => 'admin',
        password => 'b3tt3rp@ssw0rd'
    }),
    requestheaders   => Sensitive({
        'Content-Type' => 'x-application/json',
        'Auth-Token'   => '12324af3qnqev00343'
    }),
    shouldcontain    => 'not bad',
    port             => 80,
    auth             => Sensitive("admin:f00b@rb@z"),
    encryption       => true,
    tags             => ['http']
}

pingdom_check { "httpcustom://${facts['fqdn']}/status/pingdom.xml":
    ensure           => present,
    provider         => 'httpcustom',
    host             => $facts['fqdn'],
    url              => '/status/pingdom.xml',
    auth             => Sensitive('super:secret'),
    additionalurls   => [
        'http://www.domain3.com',
        'http://www.domain4.com'
    ],
    port             => 443,
    encryption       => true,
    tags             => ['http']
}

pingdom_check { "dns://${facts['fqdn']}":
    ensure           => present,
    provider         => 'dns',
    host             => $facts['fqdn'],
    expectedip       => '2.4.6.8',
    nameserver       => '4.2.2.2',
    tags             => ['dns']
}

pingdom_check { "ping://${facts['fqdn']}":
    ensure           => present,
    provider         => 'ping',
    host             => '8.8.8.8',
    tags             => ['ping']
}

pingdom_check { "imap://${facts['fqdn']}":
    ensure         => present,
    provider       => 'imap',
    host           => $facts['fqdn'],
    port           => 993,
    stringtoexpect => 'Courier IMAP v4',
    encryption     => true,
    tags           => ['imap']
}

pingdom_check { "pop3://${facts['fqdn']}":
    ensure         => present,
    provider       => 'pop3',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Courier POP3 v4',
    encryption     => true,
    paused         => true,
    tags           => ['pop3']
}

pingdom_check { "smtp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'smtp',
    host           => $facts['fqdn'],
    port           => 995,
    stringtoexpect => 'Postfix v3',
    encryption     => true,
    tags           => ['smtp']
}

pingdom_check { "tcp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'tcp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'hi',
    stringtoexpect => 'hola',
    encryption     => true,
    paused         => true,
    tags           => ['tcp']
}

pingdom_check { "udp://${facts['fqdn']}":
    ensure         => present,
    provider       => 'udp',
    host           => $facts['fqdn'],
    port           => 1234,
    stringtosend   => 'aloha',
    stringtoexpect => 'zdravo',
    encryption     => true,
    tags           => ['udp']
}

