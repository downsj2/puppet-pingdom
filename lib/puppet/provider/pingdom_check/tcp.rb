Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    def port
        @check.fetch('port', :absent)
    end

    def stringtosend
        @check.fetch('stringtosend', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end

    def do_apply
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtosend   => @resource[:stringtosend],
            :stringtoexpect => @resource[:stringtoexpect],
        })
        update_or_create 'tcp', attrs
    end
end