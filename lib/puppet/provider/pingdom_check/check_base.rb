#
# Base class for all Check providers.
#
# Provider must:
# - have `:parent => :check_base` in their declaration.
# - declare any new properties as features using `has_features`.
# - create setters/getters for provider-specific properties
#   that require special handling (optional).
# - call `accessorize` at the end to create any setters/getters
#   not already defined.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

API_VERSION = '2.0'

# require PuppetX module
begin
    require File.expand_path( # yes, this is the recommended way :P
        File.join(
            File.dirname(__FILE__), '..', '..', '..',
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
        @api ||= begin
            raise 'Missing API credentials' if [
                @resource[:username],
                @resource[:password],
                @resource[:appkey]
            ].include? nil

            PuppetX::Pingdom::Client.new(
                @resource[:username],
                @resource[:password],
                @resource[:appkey]
            )
        end
    end

    def exists?
        @check ||= api.find_check @resource[:name]
    end

    def create
        # Dummy method. Real work is done in `flush`. Providers generally call
        # `create` followed by `flush`. This results in excessive calls to
        # external resources, in this case an internet API that could invoke
        # throttling or simply be slow.
        # To avoid this, instead of creating a basic resource using `create`
        # and then fixing its properties via a second call to `flush`, we just
        # do it all in `flush`. Requires a bit more work in Ruby code, but cuts
        # the number of API calls in half.
    end

    def flush
        @resource.eachproperty do |prop|
            prop = prop.to_s.to_sym
            self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end

        @property_hash.update({
            :name                     => @resource[:name],
            :use_legacy_notifications => @resource[:use_legacy_notifications]
        })

        @check = if @check
            api.modify_check @check, @property_hash
        else
            @property_hash[:type] = @resource[:provider]
            api.create_check @resource[:name], @property_hash
        end
    end

    def destroy
        api.delete_check @check
        @resource[:ensure] = :absent
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
        raise 'Unknown contact in list' unless contacts.size == value.size
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
    def self.accessorize
        # Provides automatic creation of missing getters/setters (accessors).
        #
        # Similar to mk_resource_methods, but doesn't clobber existing methods, thank you.
        # This allows us to have special cases explicitly defined, while still benefitting
        # from accessor auto-creation (which this class method provides).
        # Should be called at the end of every provider definition (unless you explicitly
        # define every single getter/setter).

        [ resource_type.validproperties, resource_type.parameters ].flatten.each do |prop|
            # It should be noted that this loops over all properties for all check providers.
            # This is unfortunate, but we are protected against invalid properties by the
            # `required_features` defined on each property in the type declarations.
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

    accessorize
end
