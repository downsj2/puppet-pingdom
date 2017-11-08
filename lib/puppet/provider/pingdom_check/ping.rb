Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check_base) do
    accessorize
end