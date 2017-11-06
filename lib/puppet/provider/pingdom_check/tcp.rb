Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check_base) do
    has_features :port, :stringtosend, :stringtoexpect

    update_resource_methods
end