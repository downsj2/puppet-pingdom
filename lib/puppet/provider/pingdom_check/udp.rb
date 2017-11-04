Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :api) do
    has_features :port, :stringtosend, :stringtoexpect

    def update_or_create
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtosend   => @resource[:stringtosend],
            :stringtoexpect => @resource[:stringtoexpect],
        })
        if @check
            api.modify_check @check, attrs
        else
            params[:type] = 'udp'
            api.create_check @resource[:name], attrs
        end
    end

    #
    # getters
    #
    def port
        @check.fetch('port', :absent)
    end

    def stringtosend
        @check.fetch('stringtosend', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end
end