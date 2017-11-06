Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check) do
    has_features :host, :port, :url, :auth, :encryption
    defaultfor :feature => :posix

    def encryption
        begin
            @check['type']['http']['encryption']
        rescue => exception
            :absent
        end
    end

    def host
        @check.fetch('hostname', :absent)
    end

    def port
        begin
            @check['type']['http']['port']
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

    update_resource_methods
end