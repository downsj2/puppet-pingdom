#
# Team provider.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'pingdom.rb'))

Puppet::Type.type(:pingdom_team).provide(:team, :parent => Puppet::Provider::Pingdom) do

    def exists?
        @team ||= api.find_team @resource[:name]
    end

    def flush
        if @resource[:ensure] == :absent
            api.delete_team @team if @team
            return
        end

        @resource.eachproperty do |prop|
            prop = prop.to_s.to_sym
            self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end
        @property_hash[:name] = @resource[:name]

        if @team
            api.modify_team @team, @property_hash
        else
            api.create_team @property_hash
        end
    end

    def destroy
        @resource[:ensure] = :absent
    end

    #
    # custom getters/setters
    #
    def users
        # accepts list of ids, returns list of names
        ids = @team.fetch('users', {}).map { |i| i['id'].to_i }
        user = api.select_users(ids, search='id') if ids
        if user.respond_to? :map
            user.map { |u| u['name'] }
        else
            :absent
        end
    end

    def users=(value)
        # accepts list of names, returns list of ids
        users = api.select_users(value, search='name')
        raise 'Unknown user in list' unless users.size == value.size
        ids = users.map { |u| u['id'] }
        newvalue = ids.join(',') if ids.respond_to? :join
        @property_hash[:userids] = newvalue
    end

    accessorize :@team
end
