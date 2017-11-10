#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

Puppet::Type.newtype(:pingdom_contact) do
    @doc = 'Pingdom Contacts API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the contact.'
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
    newproperty(:email) do
        desc 'Contact email [String].'
    end

    newproperty(:cellphone) do
        desc 'Contact cellphone [String].'

        def insync?(is)
            if is == :absent
                return should.nil?
            end

            # for some reason Pingdom prepends the country code, remove it
            should.nil? or is.split('-')[1..-1].join('-') == should
        end
    end

    newproperty(:countrycode) do
        desc %q(Cellphone country code (Requires cellphone and countryiso)[String])
        # Pingdom doesn't return this value, instead they prepend it to cellphone.
    end

    newproperty(:countryiso) do
        desc %q(Cellphone country ISO code.
                For example: US (USA), GB (Britain) or SE (Sweden)
                (Requires cellphone andcountrycode) [String])
    end

    newproperty(:defaultsmsprovider) do
        desc %q(Default SMS provider
                [String one of ('clickatell', 'bulksms', 'esendex','cellsynt')])
    end

    newproperty(:directtwitter) do
        desc %q(Send tweets as direct messages [Boolean])
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:paused) do
        desc %q(Don't send alerts to this contact [Boolean])
        newvalues(:true, :false)
    end

    newproperty(:twitteruser) do
        desc %q(Twitter username [String])
    end
end