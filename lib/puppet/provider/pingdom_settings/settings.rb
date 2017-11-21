#
# Settings provider
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'pingdom.rb'))

Puppet::Type.type(:pingdom_settings).provide(:settings, :parent => Puppet::Provider::Pingdom) do

    def exists?
        @settings ||= api.settings
    end

    def flush
        @resource.eachproperty do |prop|
            prop = prop.to_s.to_sym
            self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end
        api.modify_settings @property_hash
    end

    accessorize :@settings
end