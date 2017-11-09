Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check_base) do
    has_features :port, :auth, :stringtoexpect, :encryption

    def auth
        begin
            username = @check['type'][self.name]['username']
            password = @check['type'][self.name]['password']
            "#{username}:#{password}"
        rescue => exception
            :absent
        end
    end

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