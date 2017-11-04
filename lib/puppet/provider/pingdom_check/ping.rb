Puppet::Type.type(:pingdom_check).provide(:ping, :parent => :api) do
    has_features :host

    def update_or_create
        params = {
            :name                     => @resource[:name],
            :host                     => @resource[:host],
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
        puts "Debug(#{__method__}): #{params}" if @resource[:debug]
        if @check
            api.modify_check @check, params
        else
            params[:type] = 'ping'
            api.create_check @resource[:name], params
        end
    end

    #
    # getters
    #
    def host
        @check.fetch('host', :absent)
    end
end