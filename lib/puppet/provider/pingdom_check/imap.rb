Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :check) do
    has_features :port, :stringtoexpect, :encryption

    update_resource_methods
end