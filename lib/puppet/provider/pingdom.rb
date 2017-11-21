class Puppet::Provider::Pingdom < Puppet::Provider

    require File.expand_path(File.join(File.dirname(__FILE__),
        '..', '..', 'puppet_x', 'pingdom', 'client-2.1.rb'
    ))

    initvars

    def api
        @api ||= begin
            args = if @resource[:credentials_file]
                require 'yaml'
                creds = YAML.load_file(
                    File.expand_path @resource[:credentials_file]
                )
                [ creds['account_email'], creds['user_email'],
                  creds['password'], creds['appkey'] ]
            else
                raise 'Missing API credentials' if [
                    @resource[:account_email],
                    @resource[:user_email],
                    @resource[:password],
                    @resource[:appkey]
                ].include? nil
                [ @resource[:account_email], @resource[:user_email],
                  @resource[:password], @resource[:appkey] ]
            end

            args << @resource[:log_level]
            PuppetX::Pingdom::Client.new *args
        end
    end

    def self.accessorize(resource)
        # Provides automatic creation of missing getters/setters (accessors).
        #
        # Similar to mk_resource_methods, but doesn't clobber existing methods, thank you.
        # It also allows us to pass in the name of the resource hash to read from.
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
                    instance_variable_get(resource).fetch(prop.to_s, :absent)
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

    def create
    end

    def destroy
    end
end