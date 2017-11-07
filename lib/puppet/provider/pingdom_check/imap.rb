Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :check_base) do
    has_features :port, :stringtoexpect, :encryption
    accessorize
end