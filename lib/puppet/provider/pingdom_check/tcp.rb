Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check_base) do
    has_features :host, :port, :stringtosend, :stringtoexpect

    def host
        @check.fetch('hostname', :absent)
    end

    def port
        begin
            @check['type']['tcp']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type']['tcp']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    def stringtosend
        begin
            @check['type']['tcp']['stringtosend']
        rescue => exception
            :absent
        end
    end

    accessorize
end