Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :api) do
    has_features :port, :auth, :stringtoexpect, :encryption

    def do_apply
        attrs = update_attributes({
            :port           => @resource[:port],
            :auth           => @resource[:auth],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption]
        })
        update_or_create 'smtp', attrs
    end

    #
    # getters
    #
    def port
        @check.fetch('port', :absent)
    end

    def auth
        @check.fetch('auth', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end

    def encryption
        @check.fetch('encryption', :absent)
    end
end