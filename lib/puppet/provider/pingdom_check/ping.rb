Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    has_features :host

    def host
        @check.fetch('hostname', :absent)
    end

    def host=(value)
        @property_hash[:host] = value
    end

    def do_apply
        update_or_create :ping, {
            :host => @property_hash[:host]
        }
    end
end