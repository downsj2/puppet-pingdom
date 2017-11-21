#
# User provider.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'pingdom.rb'))

Puppet::Type.type(:pingdom_user).provide(:user, :parent => Puppet::Provider::Pingdom) do

    def exists?
        @user ||= api.find_user @resource[:name]
    end

    def create
        # Pingdom for some reason decided to make user creation
        # a two-phase process in 2.1. So we can only pass the `name`
        # when creating a user, and have to modify the user
        # in a second API call.
        @user = api.create_user :name => @resource[:name]
        @user[:name] = @resource[:name]
    end

    def flush
        if @resource[:ensure] == :absent
            api.delete_user @user if @user
            return
        end

        @resource.eachproperty do |prop|
            prop = prop.to_s.to_sym
            self.method("#{prop}=").call @resource[prop] if prop != :ensure
        end
        @property_hash[:name] = @resource[:name]

        @user = api.modify_user @user, @property_hash
    end

    def destroy
        @resource[:ensure] = :absent
    end

    #
    # custom getters/setters
    #
    def contact_targets
        targets = []
        @user['email'].each do |email|
            targets << {
                'id' => email['id'],
                'email' => email['address'],
                'severity' => email['severity']
            }
        end if @user['email'].respond_to? :each

        @user['sms'].each do |sms|
            targets << {
                'id' => sms['id'],
                'number' => sms['number'],
                'countrycode' => sms['country_code'],
                'severity' => sms['severity']
            }
        end if @user['sms'].respond_to? :each

        @property_hash[:old_contact_targets] = targets
    end

    def contact_targets=(value)
        value.each do |v|
            v[:severitylevel] = v.delete('severity') if v.include? 'severity'
        end
        @property_hash[:contact_targets] = value
    end

    def paused
        if @user.include? 'paused'
            (@user['paused'] == 'YES').to_s.to_sym
        else
            :absent
        end
    end

    def paused=(value)
        @property_hash[:paused] = { :true => 'YES', :false => 'NO' }[value]
    end

    def primary
        if @user.include? 'primary'
            (@user['primary'] == 'YES').to_s.to_sym
        else
            :absent
        end
    end

    def primary=(value)
        @property_hash[:primary] = { :true => 'YES', :false => 'NO' }[value]
    end

    accessorize :@user
end
