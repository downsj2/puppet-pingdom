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

API_VERSION = '2.0'

begin # load puppet_x/pingdom/client.rb
    require File.expand_path( # yes, this is the recommended way :P
        File.join(
            File.dirname(__FILE__),
            '..', '..', '..',
            'puppet_x', 'pingdom', "client-#{API_VERSION}.rb"
        )
    )
    has_pingdom_api = true
rescue LoadError
    has_pingdom_api = false
end

Puppet::Type.type(:pingdom_check).provide(:check) do
    has_features :paused, :tags, :ipv6, :notifyagainevery, :notifywhenbackup,
                 :probe_filters, :resolution, :sendnotificationwhendown,
                 :sendtoandroid, :sendtoemail, :sendtoiphone, :sendtosms, :sendtotwitter
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
        @resource.eachproperty do |prop|
            prop = prop.to_s
            # call setters to allow for restructuring of property data
            @property_hash[prop] = self.method("#{prop}=").call(@resource[prop])
        end
    end

    def destroy
        api.delete_check(@check)
        @resource[:ensure] = :absent
    end

    def flush
        @check = do_apply unless @resource[:ensure] == :absent
    end

    def apply_properties(provider_props)
        props = {
            :name                     => @resource[:name],
            :use_legacy_notifications => @resource[:use_legacy_notifications],
            :paused                   => @property_hash[:paused],
            :resolution               => @property_hash[:resolution],
            :ipv6                     => @property_hash[:ipv6],
            :tags                     => @property_hash[:tags],
            :probe_filters            => @property_hash[:probe_filters],
            :notifyagainevery         => @property_hash[:notifyagainevery],
            :notifywhenbackup         => @property_hash[:notifywhenbackup],
            :sendnotificationwhendown => @property_hash[:sendnotificationwhendown],
            :sendtoandroid            => @property_hash[:sendtoandroid],
            :sendtoemail              => @property_hash[:sendtoemail],
            :sendtoiphone             => @property_hash[:sendtoiphone],
            :sendtosms                => @property_hash[:sendtosms],
            :sendtotwitter            => @property_hash[:sendtotwitter]
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
    def ensure
        @check.fetch('ensure', :absent)
    end

    def ensure=(value)
        @property_hash[:ensure] = value
    end

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
        newvalue = value.join(',') if value.respond_to? :join
        @property_hash[:tags] = newvalue
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
        newvalue = value.map { |v| 'region: ' + v }.join(',') if value.respond_to? :map
        @property_hash[:probe_filters] = newvalue
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

    def sendtoandroid
        @check.fetch('sendtoandroid', :absent)
    end

    def sendtoandroid=(value)
        @property_hash[:sendtoandroid] = value
    end

    def sendtoemail
        @check.fetch('sendtoemail', :absent)
    end

    def sendtoemail=(value)
        @property_hash[:sendtoemail] = value
    end

    def sendtoiphone
        @check.fetch('sendtoiphone', :absent)
    end

    def sendtoiphone=(value)
        @property_hash[:sendtoiphone] = value
    end

    def sendtosms
        @check.fetch('sendtosms', :absent)
    end

    def sendtosms=(value)
        @property_hash[:sendtosms] = value
    end

    def sendtotwitter
        @check.fetch('sendtotwitter', :absent)
    end

    def sendtotwitter=(value)
        @property_hash[:sendtotwitter] = value
    end
end