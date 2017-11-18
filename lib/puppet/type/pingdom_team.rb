#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

Puppet::Type.newtype(:pingdom_team) do
    @doc = 'Pingdom Teams API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the team.'
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

    newparam(:log_level) do
        desc 'Logging level for API requests [String (ERROR, WARN, INFO, DEBUG)]'
        newvalues(:error, :warn, :info, :debug)
        defaultto :error
    end

    #
    # common properties
    #
    newproperty(:users, :array_matching=>:all) do
        desc 'User names [list of strings].'

        def insync?(is)
            case is
                when :absent
                    should.nil?
                else
                    should.nil? or is.sort == should.sort
            end
        end
    end

    #
    # autorequires
    #
    autorequire(:pingdom_user) do
        self[:users]
    end
end