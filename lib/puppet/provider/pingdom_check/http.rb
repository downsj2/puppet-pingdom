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
        api.find_check @resource[:name]
    end

    def create
        params = {
            :type                     => 'http',
            :name                     => @resource[:name],
            :host                     => @resource[:host],
            :url                      => @resource[:url],
            :paused                   => @resource[:paused],
            :resolution               => @resource[:resolution],
            :sendnotificationwhendown => @resource[:sendnotificationwhendown],
            :notifywhenbackup         => @resource[:notifywhenbackup],
            :ipv6                     => @resource[:ipv6],
            :notifyagainevery         => @resource[:notifyagainevery],
            :responsetime_threshold   => @resource[:responsetime_threshold],
            :userids                  => @resource[:userids].sort.join(','),
            :probe_filters            => @resource[:probe_filters].sort.join(','),
            :integrationids           => @resource[:integrationids].sort.join(','),
            :teamids                  => @resource[:teamids].sort.join(','),
            :tags                     => @resource[:tags].sort.join(',')
        }
        if check = api.find_check(@resource[:name])
            api.modify_check check, params
        else
            api.create_check @resource[:name], params
        end
    end

    def destroy
        check = api.find_check @resource[:name]
        api.delete_check(check) unless check.nil?
    end
end