Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    update_resource_methods
end