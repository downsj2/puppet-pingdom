Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :check) do
    has_features :port, :stringtoexpect, :encryption

    def encryption
        @check.fetch('encryption', :absent)
    end

    def encryption=(value)
        @property_hash[:encryption] = value
    end

    def port
        @check.fetch('port', :absent)
    end

    def port=(value)
        @property_hash[:port] = value
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end

    def stringtoexpect=(value)
        @property_hash[:stringtoexpect] = value
    end

    def do_apply
        update_or_create 'imap', apply_properties({
            :port           => @resource[:port],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption]
        })
    end
end