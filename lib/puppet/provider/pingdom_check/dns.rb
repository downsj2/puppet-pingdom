Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check) do
    has_features :hostname, :expectedip, :nameserver

    mk_resource_methods

    def nameserver
        begin
            @check['type']['dns']['nameserver']
        rescue => exception
            :absent
        end
    end

    def do_apply
        attrs = update_attributes({
            :host       => @resource[:hostname],
            :expectedip => @resource[:expectedip],
            :nameserver => @resource[:nameserver],
        })
        update_or_create 'dns', attrs
    end
end