Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :check) do
    has_features :port, :stringtoexpect, :encryption

    def do_apply
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption],
        })
        update_or_create 'pop3', attrs
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