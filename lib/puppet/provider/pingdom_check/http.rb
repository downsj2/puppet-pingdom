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
        update_or_create
    end

    def destroy
        check = api.find_check @resource[:name]
        api.delete_check(check) unless check.nil?
    end

    def flush
        update_or_create
    end

    def update_or_create
        params = {
            :name           => @resource[:name],
            :host           => @resource[:host],
            :url            => @resource[:url],
            :paused         => @resource[:paused],
            :resolution     => @resource[:resolution],
            :ipv6           => @resource[:ipv6],
            :userids        => @resource[:userids].sort.join(','),
            :probe_filters  => @resource[:probe_filters].sort.join(','),
            :integrationids => @resource[:integrationids].sort.join(','),
            :teamids        => @resource[:teamids].sort.join(','),
            :tags           => @resource[:tags].sort.join(',')
        }
        if check = api.find_check(@resource[:name])
            api.modify_check check, params
        else
            params[:type] = 'http'
            api.create_check @resource[:name], params
        end
    end

    #
    # getters
    #
    def host
        if check = api.find_check(@resource[:name])
            check.fetch('hostname', :absent)
        end
    end

    def ipv6
        if check = api.find_check(@resource[:name])
            check.fetch('ipv6', :absent)
        end
    end

    def paused
        if check = api.find_check(@resource[:name])
            check.fetch('status', :absent) == 'paused'
        end
    end

    def resolution
        if check = api.find_check(@resource[:name])
            check.fetch('resolution', :absent)
        end
    end

    def tags
        if check = api.find_check(@resource[:name])
            check.fetch('tags', []).map { |tag| tag['name'] }
        else
            :absent
        end
    end

    def url
        if check = api.find_check(@resource[:name])
            check['type']['http']['url']
        else
            :absent
        end
    end
end