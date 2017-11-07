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
        @property_hash.update({
            :name                     => @resource[:name],
            :use_legacy_notifications => @resource[:use_legacy_notifications]
        })

        @resource.eachproperty do |prop|
            prop = prop.to_s
            self.method("#{prop}=").call @resource[prop] if prop != 'ensure'
        end

        if @check
            api.modify_check @check, @property_hash
        else
            @property_hash[:type] = @resource[:provider]
            api.create_check @resource[:name], @property_hash
        end
    end

    #
    # custom getters/setters
    #
    def contacts
        # returns list of email addresses
        ids = @check.fetch('contactids', '')
        contact = api.select_contacts(ids, search='id')
        if contact.respond_to? :map
            contact.map { |contact| contact['email'] }
        end
    end

    def contacts=(value)
        # accepts list of email addresses, converts to ids
        contacts = api.select_contacts(value, search='email')
        ids = contacts.map { |contact| contact['id'] }
        newvalue = ids.join(',') if ids.respond_to? :join
        @property_hash[:contactids] = newvalue
    end

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
        [resource_type.validproperties, resource_type.parameters].flatten.each do |prop|
            prop = prop.to_sym
            next if prop == :name

            if !method_defined?(prop)
                define_method(prop) do
                    @check.fetch(prop.to_s, :absent)
                end
            end

            setter = "#{prop}=".to_sym
            if !method_defined?(setter)
                define_method(setter) do |value|
                    @property_hash[prop] = value
                end
            end
        end
    end

    update_resource_methods
end