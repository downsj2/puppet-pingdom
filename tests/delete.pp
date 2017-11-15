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
#     `export RUBYLIB=$PWD/lib ; puppet apply tests/delete.pp`

Pingdom_check {
    credentials_file => '~/.pingdom_credentials'
}

$checks = [
  "http://${facts['fqdn']}/check",
  "httpcustom://${facts['fqdn']}/status/pingdom.xml",
  "dns://${facts['fqdn']}",
  "ping://${facts['fqdn']}",
  "imap://${facts['fqdn']}",
  "pop3://${facts['fqdn']}",
  "smtp://${facts['fqdn']}",
  "tcp://${facts['fqdn']}",
  "udp://${facts['fqdn']}"
]

pingdom_check { $checks:
    ensure => absent
}

Pingdom_user {
    credentials_file => '~/.pingdom_credentials'
}

$users = [ 'SRE PagerDuty', 'DevOps', 'DevOps Pager']
pingdom_user { $users:
    ensure => absent
}
