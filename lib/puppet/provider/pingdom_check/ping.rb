Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :api) do
    has_features :host

    def update_or_create
        attrs = update_attributes({
            :host => @resource[:host],
        })
        puts "Debug(#{__method__}): #{params}" if @resource[:debug]
        if @check
            api.modify_check @check, attrs
        else
            params[:type] = 'ping'
            api.create_check @resource[:name], attrs
        end
    end

    #
    # getters
    #
    def host
        @check.fetch('host', :absent)
    end
end