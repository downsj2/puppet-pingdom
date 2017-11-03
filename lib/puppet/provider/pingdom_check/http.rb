require File.expand_path( # yes, this is the recommended way :P
    File.join(
        File.dirname(__FILE__),
        '..', '..', '..',
        'puppet_x', 'pingdom', 'client.rb'
    )
)

Puppet::Type.type(:pingdom_check).provide(:http) do
    has_feature :http

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
            :type => 'http',
            :name => @resource[:name],
            :host => @resource[:host],
            :url  => @resource[:url],
            :paused                   => @resource[:paused],
            :resolution               => @resource[:resolution],
            :sendnotificationwhendown => @resource[:sendnotificationwhendown],
            :notifywhenbackup         => @resource[:notifywhenbackup],
            :ipv6                     => @resource[:ipv6],
            :notifyagainevery         => @resource[:notifyagainevery],
            :responsetime_threshold   => @resource[:responsetime_threshold],
            :userids                  => @resource[:userids],
            :probe_filters            => @resource[:probe_filters],
            :integrationids           => @resource[:integrationids],
            :teamids                  => @resource[:teamids],
            :tags                     => @resource[:tags]
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