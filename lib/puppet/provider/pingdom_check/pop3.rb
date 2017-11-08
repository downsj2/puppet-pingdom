Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :check_base) do
    has_features :port, :stringtoexpect, :encryption

    def encryption
        begin
            @check['type']['pop3']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type']['pop3']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type']['pop3']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end