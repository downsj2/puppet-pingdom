#
# Thin wrapper around Pingdom API.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

require 'logger'
require 'json'
require 'faraday'

module PuppetX; end
module PuppetX::Pingdom; end

class PuppetX::Pingdom::Client
    @@api_host = 'https://api.pingdom.com'
    @@api_base = '/api/2.0'
    @@endpoint = {
        :checks   => "#{@@api_base}/checks",
        :contacts => "#{@@api_base}/contacts"
    }

    def initialize(username, password, appkey, logging=:ERROR)
        logger = Logger.new $stderr
        logger.level = Logger.const_get(logging)
        @api = Faraday.new(:url => @@api_host) do |faraday|
            faraday.response :logger, logger, { :bodies => true }
            faraday.request  :url_encoded
            faraday.adapter Faraday.default_adapter
        end
        @api.basic_auth(username, password)
        @api.headers['App-Key'] = appkey
    end

    #
    # Checks API
    #
    def checks
        # list of checks
        @checks ||= begin
            response = @api.get @@endpoint[:checks], { :include_tags => true }
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

    def create_check(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceChecks for params
        response = @api.post @@endpoint[:checks], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['check']
    end

    def find_check(name)
        # returns check or nil
        check = checks.select { |check| check['name'] == name } [0]
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
end
