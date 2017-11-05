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
        update_or_create 'dns', apply_properties({
            :host       => @resource[:hostname],
            :expectedip => @resource[:expectedip],
            :nameserver => @resource[:nameserver]
        })
    end
end