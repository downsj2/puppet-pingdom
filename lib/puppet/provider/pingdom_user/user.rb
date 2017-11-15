Puppet::Type.type(:pingdom_user).provide(:user, :parent => :user_base) do
    accessorize
end