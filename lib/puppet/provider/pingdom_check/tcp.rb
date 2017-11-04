Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :api) do
    has_features :port, :stringtosend, :stringtoexpect

    def update_or_create
        params = {
            :name                     => @resource[:name],
            :port                     => @resource[:port],
            :stringtosend             => @resource[:stringtosend],
            :stringtoexpect           => @resource[:stringtoexpect],
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
            params[:type] = 'tcp'
            api.create_check @resource[:name], params
        end
    end

    #
    # getters
    #
    def port
        @check.fetch('port', :absent)
    end

    def stringtosend
        @check.fetch('stringtosend', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end
end