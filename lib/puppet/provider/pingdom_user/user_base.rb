#
# Base class for all user providers.
#
# Provider must:
# - have `:parent => :user_base` in their declaration.
# - declare any new properties as features using `has_features`.
# - create setters/getters for provider-specific properties
#   that require special handling (optional).
# - call `accessorize` at the end to create any setters/getters
#   not already defined.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

begin # require PuppetX module
    require File.expand_path( # yes, this is the recommended way :P
        File.join(
            File.dirname(__FILE__), '..', '..', '..',
            'puppet_x', 'pingdom', 'client-2.1.rb'
        )
    )
    has_pingdom_api = true
rescue LoadError
    has_pingdom_api = false
end

Puppet::Type.type(:pingdom_user).provide(:user_base) do
    confine :true => has_pingdom_api

    def api
        @api ||= begin
            if @resource[:credentials_file]
                require 'yaml'
                # just let any exception bubble up
                creds = YAML.load_file(
                    File.expand_path @resource[:credentials_file]
                )
                account_email, user_email, password, appkey =
                    creds['account_email'], creds['user_email'], creds['password'], creds['appkey']
            else
                raise 'Missing API credentials' if [
                    @resource[:account_email],
                    @resource[:user_email],
                    @resource[:password],
                    @resource[:appkey]
                ].include? nil and @resource[:credentials_file].is_nil?
                account_email, user_email, password, appkey =
                    @resource[:account_email], @resource[:user_email], @resource[:password], @resource[:appkey]
            end
            PuppetX::Pingdom::Client.new(account_email, user_email, password, appkey, @resource[:log_level])
        end
    end

    def exists?
        @user ||= api.find_user @resource[:name]
    end

    def create
        # Pingdom for some reason decided to make user creation
        # a two-phase process in 2.1. So we can only pass the `name`
        # when creating a user, and have to modify the user
        # in a second API call.
        @user = api.create_user :name => @resource[:name]
        @user[:name] = @resource[:name]
    end

    def flush
        if @resource[:ensure] == :absent
            api.delete_user @user if @user
            return
        end

        @resource.eachproperty do |prop|
            prop = prop.to_s.to_sym
            self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end
        @property_hash[:name] = @resource[:name]

        @user = api.modify_user @user, @property_hash
    end

    def destroy
        @resource[:ensure] = :absent
    end

    #
    # custom getters/setters
    #
    def contact_targets
        targets = []
        @user['email'].each do |email|
            targets << {
                'id' => email['id'],
                'email' => email['address'],
                'severity' => email['severity']
            }
        end if @user['email'].respond_to? :each

        @user['sms'].each do |sms|
            targets << {
                'id' => sms['id'],
                'number' => sms['number'],
                'countrycode' => sms['country_code'],
                'severity' => sms['severity']
            }
        end if @user['sms'].respond_to? :each

        @property_hash[:old_contact_targets] = targets
    end

    def contact_targets=(value)
        value.each do |contact|
            if contact.include? 'severity'
                contact[:severitylevel] = contact['severity']
                contact.delete 'severity'
            end
        end
        @property_hash[:contact_targets] = value
    end

    def paused
        if @user.include? 'paused'
            (@user['paused'] == 'YES').to_s.to_sym
        else
            :absent
        end
    end

    def paused=(value)
        @property_hash[:paused] = { :true => 'YES', :false => 'NO' }[value]
    end

    def primary
        if @user.include? 'primary'
            (@user['primary'] == 'YES').to_s.to_sym
        else
            :absent
        end
    end

    def primary=(value)
        @property_hash[:primary] = { :true => 'YES', :false => 'NO' }[value]
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
            # It should be noted that this loops over all properties for all user providers.
            # This is unfortunate, but we are protected against invalid properties by the
            # `required_features` defined on each property in the type declarations.
            prop = prop.to_sym
            next if prop == :name

            if !method_defined?(prop)
                define_method(prop) do
                    @user.fetch(prop.to_s, :absent)
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
