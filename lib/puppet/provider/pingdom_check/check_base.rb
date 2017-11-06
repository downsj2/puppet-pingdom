#
# Base class for all check providers.
#
# Provider must
# - have `:parent => :check` in their declaration.
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

Puppet::Type.type(:pingdom_check).provide(:check_base) do
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
        @check ||= api.find_check @resource[:name]
    end

    def create
        # Dummy method. Real work is done in update_or_create.
    end

    def destroy
        api.delete_check(@check)
        @resource[:ensure] = :absent
    end

    def flush
        @check = update_or_create unless @resource[:ensure] == :absent
    end

    def update_or_create
        props = {
            :name                     => @resource[:name],
            :use_legacy_notifications => @resource[:use_legacy_notifications]
        }
        @resource.eachproperty do |prop|
            prop = prop.to_s
            value = self.method("#{prop}=").call @resource[prop] if prop != 'ensure'
            props[prop] = value unless value.nil?
        end

        if @check
            api.modify_check @check, props
        else
            props[:type] = @resource[:provider]
            api.create_check @resource[:name], props
        end
    end

    #
    # custom getters/setters
    #
    def paused
        @check.fetch('status', :absent) == 'paused'
    end

    def probe_filters=(value)
        newvalue = value.map { |v| 'region: ' + v }.join(',') if value.respond_to? :map
        @property_hash[:probe_filters] = newvalue
    end

    def tags
        @check.fetch('tags', []).map { |tag| tag['name'] }
    end

    def tags=(value)
        newvalue = value.join(',') if value.respond_to? :join
        @property_hash[:tags] = newvalue
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
                    @check.fetch(attr.to_s, :absent)
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