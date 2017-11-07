Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check_base) do
    has_features :host, :expectedip, :nameserver

    def host
        @check.fetch('hostname', :absent)
    end

    def expectedip
        begin
            @check['type']['dns']['expectedip']
        rescue => exception
            :absent
        end
    end

    def nameserver
        begin
            @check['type']['dns']['nameserver']
        rescue => exception
            :absent
        end
    end

    accessorize
end