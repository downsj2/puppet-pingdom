Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :check_base) do
    has_features :port, :stringtosend, :stringtoexpect
    accessorize
end