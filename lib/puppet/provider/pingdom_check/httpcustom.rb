Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_feature :http, :httpcustom

    def update_or_create
        params = {
            :name                     => @resource[:name],
            :host                     => @resource[:host],
            :url                      => @resource[:url],
            :encryption               => @resource[:encryption],
            :port                     => @resource[:port],
            :auth                     => @resource[:auth],
            :additionalurls           => @resource[:additionalurls],
            :paused                   => @resource[:paused],
            :resolution               => @resource[:resolution],
            :ipv6                     => @resource[:ipv6],
            :sendnotificationwhendown => @resource[:sendnotificationwhendown],
            :notifyagainevery         => @resource[:notifyagainevery],
            :notifywhenbackup         => @resource[:notifywhenbackup],
            :tags                     => @resource[:tags].sort.join(','),
            :probe_filters            => @resource[:probe_filters].sort.join(','),
            :userids                  => @resource[:userids].sort.join(','),
            :teamids                  => @resource[:teamids].sort.join(','),
            # :integrationids           => @resource[:integrationids].sort.join(',')
        }
        if @check
            api.modify_check @check, params
        else
            params[:type] = 'httpcustom'
            api.create_check @resource[:name], params
        end
    end

    #
    # getters
    #
    def additionalurls
        @check.fetch('additionalurls', :absent)
    end
end