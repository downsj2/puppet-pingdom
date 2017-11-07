Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :check_base) do
    has_features :host, :port, :stringtosend, :stringtoexpect

    def host
        @check.fetch('hostname', :absent)
    end

    def port
        begin
            @check['type']['udp']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type']['udp']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    def stringtosend
        begin
            @check['type']['udp']['stringtosend']
        rescue => exception
            :absent
        end
    end

    accessorize
end