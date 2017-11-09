Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :check_base) do
    has_features :port, :stringtoexpect, :encryption

    def encryption
        begin
            @check['type'][self.name]['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type'][self.name]['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type'][self.name]['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end