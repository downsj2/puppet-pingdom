Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    mk_resource_methods

    def do_apply
        update_or_create 'tcp', apply_properties({
            :port           => @resource[:port],
            :stringtosend   => @resource[:stringtosend],
            :stringtoexpect => @resource[:stringtoexpect],
        })
    end
end