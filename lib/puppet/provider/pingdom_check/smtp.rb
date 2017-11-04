Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :api) do
    has_features :port, :auth, :stringtoexpect, :encryption

    def update_or_create
        attrs = update_attributes({
            :port           => @resource[:port],
            :auth           => @resource[:auth],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption]
        })
        if @check
            api.modify_check @check, attrs
        else
            params[:type] = 'smtp'
            api.create_check @resource[:name], attrs
        end
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