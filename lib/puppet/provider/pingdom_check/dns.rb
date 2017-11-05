Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check) do
    has_features :hostname, :expectedip, :nameserver

    def hostname
        @check.fetch('hostname', :absent)
    end

    def hostname=(value)
        @property_hash[:hostname] = value
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

    def do_apply
        update_or_create :dns, apply_properties({
            :host       => @property_hash[:hostname],
            :expectedip => @property_hash[:expectedip],
            :nameserver => @property_hash[:nameserver]
        })
    end
end