class pingdom {
  package { 'faraday':
    ensure   => present,
    provider => 'puppet_gem'
  }

  $definitions = lookup('pingdom', Hash)

  $defaults = {
    'account_email' => $definitions['account_email'],
    'user_email'    => $definitions['user_email'],
    'password'      => $definitions['password'],
    'appkey'        => $definitions['appkey'],
    'require'       => Package['faraday']
  }

  create_resources('pingdom_user', $definitions['users'], $defaults)
  create_resources('pingdom_check', $definitions['checks'], $defaults)
}
