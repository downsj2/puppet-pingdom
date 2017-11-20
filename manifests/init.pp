class pingdom {
    $account_email = lookup('pingdom::account_email', String, 'first', false)

    $common = {
        'user_email' => lookup('pingdom::user_email', String, 'first'),
        'password'   => lookup('pingdom::password', String, 'first'),
        'appkey'     => lookup('pingdom::appkey', String, 'first')
    }

    $defaults = $account_email ? {
        default => merge($common, {'account_email' => $account_email}),
        false   => $common
    }

    $users = lookup('pingdom::users', Hash, 'hash', {})
    $teams = lookup('pingdom::teams', Hash, 'hash', {})
    $checks = lookup('pingdom::checks', Hash, 'hash', {})

    create_resources('pingdom_user', $users, $defaults)
    create_resources('pingdom_team', $teams, $defaults)
    create_resources('pingdom_check', $checks, $defaults)
}

