Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :additionalurls

    mk_resource_methods

    def update_or_create
        attrs = update_attributes({
            :host           => @resource[:host],
            :url            => @resource[:url],
            :encryption     => @resource[:encryption],
            :port           => @resource[:port],
            :auth           => @resource[:auth],
            :additionalurls => @resource[:additionalurls],
        })
        update_or_create 'httpcustom', attrs
    end
end