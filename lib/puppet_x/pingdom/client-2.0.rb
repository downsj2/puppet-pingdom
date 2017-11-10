#
# Thin wrapper around Pingdom API.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

require 'json'
require 'faraday'
require 'digest/sha1'

module PuppetX; end
module PuppetX::Pingdom; end

class PuppetX::Pingdom::Client
    @@api_host = 'https://api.pingdom.com'
    @@api_base = '/api/2.0'
    @@endpoint = {
        :checks   => "#{@@api_base}/checks",
        :contacts => "#{@@api_base}/notification_contacts"
    }

    def initialize(username, password, appkey, logging=nil)
        @api = if logging.nil?
            Faraday.new(:url => @@api_host)
        else
            require 'logger'
            logger = Logger.new $stderr
            logger.level = Logger.const_get(logging)

            Faraday.new(:url => @@api_host) do |faraday|
                faraday.response :logger, logger, { :bodies => true }
                faraday.request  :url_encoded
                faraday.adapter Faraday.default_adapter
            end
        end
        @api.basic_auth(username, password)
        @api.headers['App-Key'] = appkey
    end

    #
    # Checks API
    #
    def checks(filter_tags='')
        # list of checks
        @checks ||= begin
            params = { :include_tags => true, :tags => filter_tags.join(',') }
            response = @api.get @@endpoint[:checks], params
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['checks']
        end
    end

    def get_check_details(check)
        response = @api.get "#{@@endpoint[:checks]}/#{check['id']}"
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['check']
    end

    def create_check(params)
        # see https://www.pingdom.com/resources/api/2.0#ResourceChecks for params
        response = @api.post @@endpoint[:checks], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['check']
    end

    def find_check(name, filter_tags)
        # returns check or nil
        check = checks(filter_tags).select { |check| check['name'] == name } [0]
        get_check_details(check) if check
    end

    def modify_check(check, params)
        response = @api.put "#{@@endpoint[:checks]}/#{check['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_check(check)
        response = @api.delete @@endpoint[:checks], {
            :delcheckids => check['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def contacts
        # list of contacts
        @contacts ||= begin
            response = @api.get @@endpoint[:contacts]
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['contacts']
        end
    end

    def select_contacts(values, search='id')
        # returns list of contacts or nil
        contacts.select { |contact| values.include? contact[search] }
    end

    def create_contact(params)
        # see https://www.pingdom.com/resources/api/2.0#ResourceContacts for params
        response = @api.post @@endpoint[:contacts], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['contact']
    end

    def find_contact(name)
        # returns contact or nil
        contacts.select { |contact| contact['name'] == name } [0]
    end

    def modify_contact(contact, params)
        response = @api.put "#{@@endpoint[:contacts]}/#{contact['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_contact(contact)
        response = @api.delete @@endpoint[:contacts], {
            :delcontactids => contact['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end
end
