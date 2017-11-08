Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check_base) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders
    defaultfor :feature => :posix

    def auth
        begin
            @check['type']['http']['auth']
        rescue => exception
            :absent
        end
    end

    def encryption
        begin
            @check['type']['http']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type']['http']['port']
        rescue => exception
            :absent
        end
    end

    def postdata
        begin
            @check['type']['http']['postdata']
        rescue => exception
            :absent
        end
    end

    def requestheaders
        begin
            headers = @check['type']['http']['requestheaders']
            headers.split(',')
        rescue => exception
            :absent
        end
    end

    def requestheaders=(value)
        @property_hash[:requestheaders] = value.join(',') if value.respond_to? :join
    end

    def shouldcontain
        begin
            headers = @check['type']['http']['shouldcontain']
            headers.split(',')
        rescue => exception
            :absent
        end
    end

    def shouldnotcontain
        begin
            headers = @check['type']['http']['shouldnotcontain']
            headers.split(',')
        rescue => exception
            :absent
        end
    end

    def url
        begin
            @check['type']['http']['url']
        rescue => exception
            :absent
        end
    end

    accessorize
end