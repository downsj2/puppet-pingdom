#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

Puppet::Type.newtype(:pingdom_user) do
    @doc = 'Pingdom Users API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the user.'
    end

    newparam(:username) do
        desc 'API username [string].'
    end

    newparam(:password) do
        desc 'API password [string].'
    end

    newparam(:appkey) do
        desc 'API app key [string].'
    end

    newparam(:credentials_file) do
        desc 'YAML file containing Pingdom credentials [string]'
    end

    newparam(:logging) do
        desc 'Logging level for API requests [String (ERROR, WARN, INFO, DEBUG)]'
        newvalues(:ERROR, :WARN, :INFO, :DEBUG)
    end

    #
    # common properties
    #
    newproperty(:access_level) do
        desc %q([String ('contact', 'admin', 'owner')])
    end

    newproperty(:contact_targets, :array_matching=>:all) do
        desc %q(Contact targets [Hash of key=>value pairs])

        def insync?(is)
            if is.nil?
                return should.nil?
            end
            filtered = is.map { |contact| contact.select { |k, v| k != 'id' } }
            should.nil? or filtered = should
        end
    end

    newproperty(:countrycode) do
        desc %q(Country code [string], e.g. "1")
    end

    newproperty(:email) do
        desc %q(Email address [string])
    end

    newproperty(:number) do
        desc %q(Cellphone number [string])
    end

    newproperty(:paused) do
        desc %q(Don't send alerts to this user [Boolean])
        newvalues(:true, :false)
    end

    newproperty(:primary) do
        desc %q(This user is the primary contact [Boolean])
        newvalues(:true, :false)
    end

    newproperty(:severitylevel) do
        desc %q(Severity level [string])
    end

    newproperty(:sms, :array_matching=>:all) do
        desc %q(List of SMS targets [List of Strings])
    end

    newproperty(:type) do
        desc %q(Type of account [String ('contact', 'admin')])
        newvalues(:contact, :admin)
    end
end