Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check) do
    has_features :port, :auth, :stringtoexpect, :encryption

    update_resource_methods
end