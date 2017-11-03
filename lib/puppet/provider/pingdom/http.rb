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
        if check = client.find_check(@resource[:name])
            client.modify_check check, @resource
        else
            client.create_check @resource[:name], {
                :type => 'http',
                :name => @resource[:name],
                :host => @resource[:host],
                :url  => @resource[:url]
            }
        end
    end

    def destroy
        check = client.find_check @resource[:name]
        client.delete_check(check) unless check.nil?
    end
end