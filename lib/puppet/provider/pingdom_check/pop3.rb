Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :check_base) do
    has_features :port, :stringtoexpect, :encryption
    accessorize
end