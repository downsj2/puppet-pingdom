Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check) do
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
end