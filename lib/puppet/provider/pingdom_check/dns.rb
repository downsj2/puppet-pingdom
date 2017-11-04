Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check) do
    has_features :hostname, :expectedip, :nameserver

    def do_apply
        attrs = update_attributes({
            :host       => @resource[:hostname],
            :expectedip => @resource[:expectedip],
            :nameserver => @resource[:nameserver],
        })
        update_or_create 'dns', attrs
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