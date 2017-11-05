Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :check) do
    has_features :host

    mk_resource_methods

    def do_apply
        update_or_create 'ping', apply_properties({
            :host => @resource[:host],
        })
    end
end