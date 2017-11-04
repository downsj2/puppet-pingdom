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

Puppet::Type.type(:pingdom_check).provide(:http) do
    has_feature :http
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
        if @resource[:ensure] == :absent
            return
        end
        @check = update_or_create
    end

    def update_or_create
        params = {
            :name                     => @resource[:name],
            :host                     => @resource[:host],
            :url                      => @resource[:url],
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
            params[:type] = 'http'
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

    def integrationids
        @check.fetch(__method__, :absent)
    end

    def ipv6
        @check.fetch(__method__, :absent)
    end

    def paused
        @check.fetch('status', :absent) == __method__
    end

    def resolution
        @check.fetch(__method__, :absent)
    end

    def sendnotificationwhendown
        @check.fetch(__method__, :absent)
    end

    def notifyagainevery
        @check.fetch(__method__, :absent)
    end

    def notifywhenbackup
        @check.fetch(__method__, :absent)
    end

    def tags
        @check.fetch('tags', []).map { |tag| tag['name'] }
    end
end