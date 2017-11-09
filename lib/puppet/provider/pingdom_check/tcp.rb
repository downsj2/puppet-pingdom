Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check_base) do
    has_features :port, :stringtosend, :stringtoexpect

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

    def stringtosend
        begin
            @check['type'][self.name]['stringtosend']
        rescue => exception
            :absent
        end
    end

    accessorize
end