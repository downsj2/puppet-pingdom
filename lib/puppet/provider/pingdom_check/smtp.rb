Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check) do
    has_features :port, :auth, :stringtoexpect, :encryption

    def auth
        @check.fetch('auth', :absent)
    end

    def auth=(value)
        @property_hash[:auth] = value
    end

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
        update_or_create :smtp, apply_properties({
            :port           => @property_hash.fetch(:port, @resource[:port]),
            :auth           => @property_hash.fetch(:port, @resource[:auth]),
            :stringtoexpect => @property_hash.fetch(:port, @resource[:stringtoexpect]),
            :encryption     => @property_hash.fetch(:port, @resource[:encryption])
        })
    end
end