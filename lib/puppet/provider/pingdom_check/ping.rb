Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    has_features :host

    def host
        @check.fetch('hostname', :absent)
    end

    update_resource_methods
end