Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :api) do
    has_features :hostname, :expectedip, :nameserver

    def update_or_create
        attrs = update_attributes({
            :host       => @resource[:hostname],
            :expectedip => @resource[:expectedip],
            :nameserver => @resource[:nameserver],
        })
        if @check
            api.modify_check @check, attrs
        else
            params[:type] = 'dns'
            api.create_check @resource[:name], attrs
        end
    end

    #
    # getters
    #
    def hostname
        @check.fetch('hostname', :absent)
    end

    def expectedip
        @check.fetch('expectedip', :absent)
    end

    def nameserver
        @check['type']['dns']['nameserver']
    end
end