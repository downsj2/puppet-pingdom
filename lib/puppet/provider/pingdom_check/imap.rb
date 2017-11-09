Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :check_base) do
    has_features :encryption, :port, :stringtoexpect

    def encryption
        begin
            @check['type']['imap']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type']['imap']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type']['imap']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end