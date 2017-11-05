Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check) do
    has_features :port, :auth, :stringtoexpect, :encryption

    mk_resource_methods

    def do_apply
        update_or_create 'smtp', apply_properties({
            :port           => @resource[:port],
            :auth           => @resource[:auth],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption]
        })
    end
end