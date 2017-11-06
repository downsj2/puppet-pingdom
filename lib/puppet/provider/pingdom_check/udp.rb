Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

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

    def stringtosend
        @check.fetch('stringtosend', :absent)
    end

    def stringtosend=(value)
        @property_hash[:stringtosend] = value
    end

    def do_apply
        update_or_create :udp, {
            :port           => @property_hash[:port],
            :stringtosend   => @property_hash[:stringtosend],
            :stringtoexpect => @property_hash[:stringtoexpect]
        }
    end
end