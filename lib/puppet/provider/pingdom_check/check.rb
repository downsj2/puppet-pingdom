#
# Base class for all Check providers.
#
# Provider must:
# - have `:parent => :check` in their declaration.
# - declare any new properties as features using `has_features`.
# - create setters/getters for provider-specific properties
#   that require special handling (optional).
# - call `accessorize` at the end to create any setters/getters
#   not already defined.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'pingdom.rb'))

require 'digest'

Puppet::Type.type(:pingdom_check).provide(:check, :parent => Puppet::Provider::Pingdom) do

    def exists?
        @property_hash[:tags] ||= []
        @resource[:filter_tags] ||= []

        if [:true, :bootstrap].include? @resource[:autofilter]
            @autotag ||= 'puppet-' + Digest::SHA1.hexdigest(@resource[:name])[0..5]
            @resource[:filter_tags] << @autotag if @resource[:autofilter] != :bootstrap
            @property_hash[:tags] << @autotag
        else
            @autotag = nil
        end

        @current ||= api.find_check @resource[:name], @resource[:filter_tags]
    end

    def flush
        if @resource[:ensure] == :absent
            api.delete_check @current if @current
            return
        end

        @resource.eachproperty do |prop|
             prop = prop.to_s.to_sym
             self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end
        @property_hash[:name] = @resource[:name]

        if @current
            api.modify_check @current, @property_hash
        else
            @property_hash[:type] = @resource[:provider]
            api.create_check @property_hash
        end
    end

    def destroy
        @resource[:ensure] = :absent
    end

    #
    # common accessors
    #
    def host
        @current.fetch('hostname', :absent)
    end

    def paused
         @current.fetch('status', :absent) == 'paused'
    end

    def probe_filters
        @current.fetch('probe_filters').map { |region|
            region.split[1]
        }
    end

    def probe_filters=(value)
        newvalue = value.map { |v| 'region: ' + v }.join(',')
        @property_hash[:probe_filters] = newvalue
    end

    def tags
        @current.fetch('tags', []).select { |tag|
            tag['type'] == 'u' && tag['name'] != @autotag
        }.map { |tag| tag['name'] }
    end

    def tags=(value)
        value << @autotag if @autotag
        @property_hash[:tags] = value.join ','
    end

    def teams
        # retrieves list of ids, returns list of names
        ids = @current.fetch('teams', []).map { |i| i['id'].to_s }
        team = api.select_teams(ids, search='id') if ids
        team.map { |u| u['name'] }
    end

    def teams=(value)
        # accepts list of names, returns list of ids
        teams = api.select_teams(value, search='name')
        raise 'Unknown team in list' unless teams.size == value.size
        ids = teams.map { |u| u['id'] }
        @property_hash[:teamids] = ids
    end

    def users
        # retrieves list of ids, returns list of names
        ids = @current.fetch('userids', nil)
        user = api.select_users(ids, search='id') if ids
        if user.respond_to? :map
            user.map { |u| u['name'] }
        else
            :absent
        end
    end

    def users=(value)
        # accepts list of names, returns list of ids
        found = api.select_users(value, search='name')
        raise 'Unknown user in list' unless found.size == value.size
        ids = found.map { |u| u['id'] }
        @property_hash[:userids] = ids.join ','
    end

    accessorize
end
