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
    @doc = 'Pingdom Contact API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the contact.'
    end

    newparam(:username) do
        desc 'API username [string]'
    end

    newparam(:password) do
        desc 'API password [string]'
    end

    newparam(:appkey) do
        desc 'API app key [string]'
    end

    #
    # common properties
    #
    newproperty(:fullname) do
        desc 'Contact name [string]'
    end

    newproperty(:email) do
        desc 'Contact email [string]'
    end

    newproperty(:cellphone) do
        desc 'Contact cellphone [string]'
    end

    newproperty(:defaultsmsprovider) do
        desc 'Default SMS provider [string]'
    end

    newproperty(:directtwitter) do
        desc 'Send Twitter messages as Direct Messages [boolean]'
        newvalues(:true, :false)
    end

    newproperty(:twitteruser) do
        desc 'Twitter username [string]'
    end

    newproperty(:iphonetokens) do
        desc 'iPhone token [string]'
    end

    newproperty(:androidtokens) do
        desc 'Android token [string]'
    end

    newproperty(:paused) do
        desc 'Paused [boolean'
        newvalues(:true, :false)
    end

    newproperty(:contacttype) do
        desc 'Pingdom User (u) or Notification Contact (c) [string]'
        newvalues('u', 'c')
    end
end