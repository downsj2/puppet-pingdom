#
# Base class for all contact providers.
#
# Provider must
# - have `:parent => :contact` in their declaration.
# - create setters/getters for provider-specific
#   properties that require special handling.
# - call `update_resource_methods` at the end to create
#   any setters/getters not already defined.
# - profit.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

API_VERSION = '2.0'

begin # load puppet_x/pingdom/client.rb
    require File.expand_path( # yes, this is the recommended way :P
        File.join(
            File.dirname(__FILE__),
            '..', '..', '..',
            'puppet_x', 'pingdom', "client-#{API_VERSION}.rb"
        )
    )
    has_pingdom_api = true
rescue LoadError
    has_pingdom_api = false
end

Puppet::Type.type(:pingdom_contact).provide(:contact_base) do
    confine :true => has_pingdom_api

    def api
        raise "Missing API credentials." if [@resource[:username], @resource[:password], @resource[:appkey]].include? nil
        @api ||= PuppetX::Pingdom::Client.new(
            @resource[:username],
            @resource[:password],
            @resource[:appkey]
        )
    end

    def exists?
        @contact ||= api.find_contact @resource[:name]
    end

    def create
        # Dummy method. Real work is done in update_or_create.
    end

    def destroy
        api.delete_contact(@contact)
        @resource[:ensure] = :absent
    end

    def flush
        @contact = update_or_create unless @resource[:ensure] == :absent
    end

    def update_or_create
        props = {
            :name => @resource[:name],
        }
        @resource.eachproperty do |prop|
            prop = prop.to_s
            value = self.method("#{prop}=").call @resource[prop] if prop != 'ensure'
            props[prop] = value unless value.nil?
        end

        if @contact
            api.modify_contact @contact, props
        else
            props[:type] = @resource[:provider]
            api.create_contact @resource[:name], props
        end
    end

    #
    # custom getters/setters
    #
    def paused
        @contact.fetch('status', :absent) == 'paused'
    end

    #
    # utility methods
    #
    def self.update_resource_methods
        # Similar to mk_resource_methods, but doesn't clobber existing methods, thank you.
        [resource_type.validproperties, resource_type.parameters].flatten.each do |attr|
            attr = attr.to_sym
            next if attr == :name

            getter = attr
            if !method_defined?(getter)
                define_method(getter) do
                    @contact.fetch(attr.to_s, :absent)
                end
            end

            setter = "#{attr}="
            if !method_defined?(setter)
                define_method(setter) do |value|
                    @property_hash[attr] = value
                end
            end
        end
    end

    update_resource_methods
end