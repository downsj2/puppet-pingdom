Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check_base) do
    has_features :host

    def host
        @check.fetch('hostname', :absent)
    end

    accessorize
end