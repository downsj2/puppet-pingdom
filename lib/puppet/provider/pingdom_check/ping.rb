Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    has_features :host

    def host
        @check.fetch('hostname', :absent)
    end

    def host=(value)
        @property_hash[:host] = value
    end
end