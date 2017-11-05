Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check) do
    has_features :host, :port, :url
    defaultfor :feature => :posix

    mk_resource_methods

    def host
        @check.fetch('hostname', :absent)
    end

    def url
        begin
            @check['type']['http']['url']
        rescue => exception
            :absent
        end
    end

    def do_apply
        attrs = update_attributes({
            :host => @resource[:host],
            :url  => @resource[:url],
        })
        update_or_create 'http', attrs
    end
end