Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check_base) do
    has_features :port, :auth, :stringtoexpect, :encryption
    accessorize
end