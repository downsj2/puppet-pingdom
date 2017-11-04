Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :additionalurls

    def update_or_create
        attrs = update_attributes({
            :host           => @resource[:host],
            :url            => @resource[:url],
            :encryption     => @resource[:encryption],
            :port           => @resource[:port],
            :auth           => @resource[:auth],
            :additionalurls => @resource[:additionalurls],
        })
        if @check
            api.modify_check @check, attrs
        else
            params[:type] = 'httpcustom'
            api.create_check @resource[:name], attrs
        end
    end

    #
    # getters
    #
    def additionalurls
        @check.fetch('additionalurls', :absent)
    end
end