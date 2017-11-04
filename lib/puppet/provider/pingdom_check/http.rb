Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check) do
    has_features :host, :port, :url
    defaultfor :feature => :posix

    def do_apply
        attrs = update_attributes({
            :host => @resource[:host],
            :url  => @resource[:url],
        })
        update_or_create 'http', attrs
    end

    #
    # getters
    #
    def host
        @check.fetch('hostname', :absent)
    end

    def port
        @check.fetch('port', :absent)
    end

    def url
        @check['type']['http']['url']
    end
end