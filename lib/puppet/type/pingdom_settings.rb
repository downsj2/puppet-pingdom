#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

Puppet::Type.newtype(:pingdom_settings) do
    @doc = 'Pingdom Account Settings API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the resource. Mostly harmless.'
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
    newproperty(:firstname) do; end
    newproperty(:lastname) do; end
    newproperty(:company) do; end
    newproperty(:email) do; end
    newproperty(:billing_email) do; end
    newproperty(:cellphone) do; end
    newproperty(:cellcountrycode) do; end
    newproperty(:cellcountryiso) do; end
    newproperty(:phone) do; end
    newproperty(:phonecountrycode) do; end
    newproperty(:phonecountryiso) do; end
    newproperty(:address) do; end
    newproperty(:address2) do; end
    newproperty(:zip) do; end
    newproperty(:location) do; end
    newproperty(:state) do; end
    newproperty(:description) do; end
end