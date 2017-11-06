Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check) do
    has_features :host, :expectedip, :nameserver

    def host
        @check.fetch('hostname', :absent)
    end

    def host=(value)
        @property_hash[:host] = value
    end

    def expectedip
        begin
            @check['type']['dns']['expectedip']
        rescue => exception
            :absent
        end
    end

    def expectedip=(value)
        @property_hash[:expectedip] = value
    end

    def nameserver
        begin
            @check['type']['dns']['nameserver']
        rescue => exception
            :absent
        end
    end

    def nameserver=(value)
        @property_hash[:nameserver] = value
    end
end