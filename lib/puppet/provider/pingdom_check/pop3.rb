Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :check) do
    has_features :port, :stringtoexpect, :encryption

    mk_resource_methods

    def do_apply
        update_or_create 'pop3', apply_properties({
            :port           => @resource[:port],
            :stringtoexpect => @resource[:stringtoexpect],
            :encryption     => @resource[:encryption],
        })
    end
end