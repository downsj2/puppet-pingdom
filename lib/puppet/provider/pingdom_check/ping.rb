Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :api) do
    has_features :host

    def update_or_create
        attrs = update_attributes({
            :host => @resource[:host],
        })
        do_apply 'ping', attrs
    end

    #
    # getters
    #
    def host
        @check.fetch('host', :absent)
    end
end