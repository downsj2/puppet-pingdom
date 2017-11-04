Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :api) do
    has_features :port, :stringtoexpect, :encryption

    def update_or_create
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption]
        })
        do_apply 'imap', attrs
    end

    #
    # getters
    #
    def port
        @check.fetch('port', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end

    def encryption
        @check.fetch('encryption', :absent)
    end
end