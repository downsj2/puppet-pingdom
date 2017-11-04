Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :api) do
    has_features :port, :stringtoexpect, :encryption

    def update_or_create
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption],
        })
        do_apply 'pop3', attrs
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