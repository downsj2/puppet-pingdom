Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check) do
    has_features :host, :port, :url, :auth, :encryption
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
        update_or_create 'http', apply_properties({
            :host       => @resource[:host],
            :port       => @resource[:port],
            :url        => @resource[:url],
            :auth       => @resource[:auth],
            :encryption => @resource[:encryption]
        })
    end
end