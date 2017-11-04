begin
    require File.expand_path( # yes, this is the recommended way :P
        File.join(
            File.dirname(__FILE__),
            '..', '..', '..',
            'puppet_x', 'pingdom', 'client.rb'
        )
    )
    has_pingdom_api = true
rescue LoadError
    has_pingdom_api = false
end

Puppet::Type.type(:pingdom_check).provide(:httpcustom) do
    has_feature :http, :httpcustom
    confine :true => has_pingdom_api

    mk_resource_methods

    def api
        @api ||= PuppetX::Pingdom::Client.new(
            @resource[:username],
            @resource[:password],
            @resource[:appkey]
        )
    end

    def exists?
        @check ||= api.find_check @resource[:name]
    end

    def create
        # Dummy method. Actual creation done by flush.
    end

    def destroy
        api.delete_check(@check)
        @resource[:ensure] = :absent
    end

    def flush
        @check = update_or_create unless @resource[:ensure] == :absent
    end

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
    def host
        @check.fetch('hostname', :absent)
    end

    def url
        @check['type']['http']['url']
    end

    def encryption
        @check.fetch('encryption', :absent)
    end

    def port
        @check.fetch('port', :absent)
    end

    def auth
        @check.fetch('auth', :absent)
    end

    def additionalurls
        @check.fetch('additionalurls', :absent)
    end

    def integrationids
        @check.fetch('integrationids', :absent)
    end

    def ipv6
        @check.fetch('ipv6', :absent)
    end

    def paused
        @check.fetch('status', :absent) == 'paused'
    end

    def resolution
        @check.fetch('resolution', :absent)
    end

    def sendnotificationwhendown
        @check.fetch('sendnotificationwhendown', :absent)
    end

    def notifyagainevery
        @check.fetch('notifyagainevery', :absent)
    end

    def notifywhenbackup
        @check.fetch('notifywhenbackup', :absent)
    end

    def tags
        @check.fetch('tags', []).map { |tag| tag['name'] }
    end
end