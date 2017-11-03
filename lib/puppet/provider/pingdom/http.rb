require File.expand_path( # yes, this is the recommended way :P
    File.join(
        File.dirname(__FILE__),
        '..', '..', '..',
        'puppet_x', 'pingdom', 'client.rb'
    )
)

Puppet::Type.type(:pingdom).provide(:http) do
    has_feature :http

    mk_resource_methods

    def client
        @client ||= PuppetX::Pingdom::Client.new(
            @resource[:username],
            @resource[:password],
            @resource[:appkey]
        )
    end

    def exists?
        client.find_check @resource[:name]
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
        if check = client.find_check(@resource[:name])
            client.modify_check check, params
        else
            client.create_check @resource[:name], params
        end
    end

    def destroy
        check = client.find_check @resource[:name]
        client.delete_check(check) unless check.nil?
    end
end