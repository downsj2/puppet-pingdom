#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#
require 'set'

Puppet::Type.newtype(:pingdom_user) do
    @doc = 'Pingdom Users API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the user.'
    end

    newparam(:account_email) do
        desc 'Account email [string].'
    end

    newparam(:user_email) do
        desc 'User email [string].'
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
    newproperty(:contact_targets, :array_matching=>:all) do
        desc %q(Contact targets [Hash of key=>value pairs])

        def insync?(is)
            if is.nil?
                return should.nil?
            end

            # this is a bit convoluted as Pingdom always returns severity, so
            # if the user didn't specify a severity, then we skip that comparison
            should.each do |s|
                type = s.include?('email') ? 'email' : 'number'
                i = is.select { |contact| contact.fetch(type, nil) == s[type] }
                return false if i.empty?
                i = i.first
                s['severity'] ||= i['severity']
                return false if s['severity'] != i['severity']
                return false if (s['countrycode'] != i['countrycode'] && type == 'number')
            end

            true
        end

        validate do |value|
            severity = value.fetch('severity', nil)
            raise "Invalid severity level `#{severity}`" if !['HIGH', 'LOW', nil].include? severity

            keyset = Set.new(value.keys)
            if keyset.subset? Set['email', 'severity']
                required = Set['email']
                if required.subset? keyset
                    return
                else
                    raise "Missing required parameter(s): #{(required - keyset).to_a}"
                end
            elsif keyset.subset? Set['number', 'countrycode', 'severity']
                required = Set['number', 'countrycode']
                if required.subset? keyset
                    return
                else
                    raise "Missing required parameter(s): #{(required - keyset).to_a}"
                end
            end
            raise "Invalid contact_target specified: #{value}"
        end
    end

    newproperty(:paused) do
        desc %q(Don't send alerts to this user [Boolean])
        newvalues(:true, :false)
    end

    newproperty(:primary) do
        desc %q(This user is the primary contact [Boolean])
        newvalues(:true, :false)
    end
end