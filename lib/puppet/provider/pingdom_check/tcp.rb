Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :api) do
    has_features :port, :stringtosend, :stringtoexpect

    def update_or_create
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtosend   => @resource[:stringtosend],
            :stringtoexpect => @resource[:stringtoexpect],
        })
        do_apply 'tcp', attrs
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