Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :api) do
    has_features :port, :stringtoexpect, :encryption

    def update_or_create
        params = {
            :name                     => @resource[:name],
            :port                     => @resource[:port],
            :stringtoexpect           => @resource[:stringtoexpect],
            :encryption               => @resource[:encryption],
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
            params[:type] = 'pop3'
            api.create_check @resource[:name], params
        end
    end

    #
    # getters
    #
    def port
        @check.fetch('port', :absent)
    end

    def stringtoexpect
        @check.fetch('stringtoexpect', :absent)
    end

    def encryption
        @check.fetch('encryption', :absent)
    end
end