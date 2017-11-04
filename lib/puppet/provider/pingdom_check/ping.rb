Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :api) do
    has_features :host

    def do_apply
        attrs = update_attributes({
            :host => @resource[:host],
        })
        update_or_create 'ping', attrs
    end

    #
    # getters
    #
    def host
        @check.fetch('host', :absent)
    end
end