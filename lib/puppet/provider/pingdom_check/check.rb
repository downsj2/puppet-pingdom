#
# Base class for all check providers.
#
# Provider must
# - have `:parent => :check` in their declaration
# - override the `do_apply` method and update any
#   provider-specific properties using `apply_properties`
# - create any setters/getters for additional properties
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

begin # load puppet_x/pingdom/client.rb
    require File.expand_path( # yes, this is the recommended way :P
        File.join(
            File.dirname(__FILE__),
            '..', '..', '..',
            'puppet_x', 'pingdom', 'client.rb'
        )
    )
    has_pingdom_api = true
rescue LoadError
    has_pingdom_api = false
end

Puppet::Type.type(:pingdom_check).provide(:check) do
    confine :true => has_pingdom_api

    def api
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
        # Dummy method. Actual creation done by flush.
    end

    def destroy
        api.delete_check(@check)
        @resource[:ensure] = :absent
    end

    def flush
        # @property_hash is populated with properties
        @check = do_apply unless @resource[:ensure] == :absent
    end

    def apply_properties(provider_props)
        props = {
            :name                     => @resource[:name],
            :paused                   => @resource[:paused],
            :resolution               => @resource[:resolution],
            :ipv6                     => @resource[:ipv6],
            :sendnotificationwhendown => @resource[:sendnotificationwhendown],
            :notifyagainevery         => @resource[:notifyagainevery],
            :notifywhenbackup         => @resource[:notifywhenbackup],
            :tags                     => @resource[:tags].sort.join(','),
            :probe_filters            => @resource[:probe_filters].sort.join(','),
            :userids                  => @resource[:userids].sort.join(','),
            :teamids                  => @resource[:teamids].sort.join(','),
            :integrationids           => @resource[:integrationids].sort.join(',')
        }
        props.update(provider_props)
    end

    def update_or_create(type, props)
        if @check
            api.modify_check @check, props
        else
            props[:type] = type
            api.create_check @resource[:name], props
        end
    end

    def do_apply
        # override in provider
    end

    #
    # common getters/setters
    #
    def paused
        @check.fetch('status', :absent) == 'paused'
    end

    def paused=(value)
        @property_hash[:paused] = value
    end

    def tags
        @check.fetch('tags', []).map { |tag| tag['name'] }
    end

    def tags=(value)
        @property_hash[:tags] = value
    end

    def teamids
        @check.fetch('teamids', []).map { |team| team['id'] }
    end

    def teamids=(value)
        @property_hash[:teamids] = value
    end

    def userids
        @check.fetch('userids', []).map { |user| user['id'] }
    end

    def userids=(value)
        @property_hash[:userids] = value
    end

    def integrationids
        @check.fetch('integrationids', []).map { |integration| integration['id'] }
    end

    def integrationids=(value)
        @property_hash[:integrationids] = value
    end

    def ipv6
        @check.fetch('ipv6', :absent)
    end

    def ipv6=(value)
        @property_hash[:ipv6] = value
    end

    def notifyagainevery
        @check.fetch('notifyagainevery', :absent)
    end

    def notifyagainevery=(value)
        @property_hash[:notifyagainevery] = value
    end

    def notifywhenbackup
        @check.fetch('notifywhenbackup', :absent)
    end

    def notifywhenbackup=(value)
        @property_hash[:notifywhenbackup] = value
    end

    def probe_filters
        @check.fetch('probe_filters', :absent)
    end

    def probe_filters=(value)
        @property_hash[:probe_filters] = value
    end

    def resolution
        @check.fetch('resolution', :absent)
    end

    def resolution=(value)
        @property_hash[:resolution] = value
    end

    def sendnotificationwhendown
        @check.fetch('sendnotificationwhendown', :absent)
    end

    def sendnotificationwhendown=(value)
        @property_hash[:sendnotificationwhendown] = value
    end
end