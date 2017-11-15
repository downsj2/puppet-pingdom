class pingdom {
  ensure_packages(['faraday'], {
    ensure   => present,
    provider => 'puppet_gem'
  })

  # $definitions = lookup('pingdom', Hash)
  $definitions = hiera('pingdom')

  $defaults = {
    'account_email' => pick($definitions['account_email'], 'Missing parameter `account_email`'),
    'user_email'    => pick($definitions['user_email'], 'Missing parameter `user_email`'),
    'password'      => pick($definitions['password'], 'Missing parameter `password`'),
    'appkey'        => pick($definitions['appkey'], 'Missing parameter `appkey`'),
    'require'       => Package['faraday']
  }

  create_resources('pingdom_user', $definitions['users'], $defaults)
  create_resources('pingdom_check', $definitions['checks'], $defaults)
}
