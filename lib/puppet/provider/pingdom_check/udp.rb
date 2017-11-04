Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :api) do
    has_features :port, :stringtosend, :stringtoexpect

    def do_apply
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtosend   => @resource[:stringtosend],
            :stringtoexpect => @resource[:stringtoexpect],
        })
        update_or_create 'udp', attrs
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