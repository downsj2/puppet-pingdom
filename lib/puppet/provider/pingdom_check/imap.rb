Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :check) do
    has_features :port, :stringtoexpect, :encryption

    def port
        @check.fetch('port', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end

    def encryption
        @check.fetch('encryption', :absent)
    end

    def do_apply
        attrs = update_attributes({
            :port           => @resource[:port],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption]
        })
        update_or_create 'imap', attrs
    end
end