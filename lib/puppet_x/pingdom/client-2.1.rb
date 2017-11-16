#
# Thin wrapper around Pingdom API.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

module PuppetX; end
module PuppetX::Pingdom; end

begin
    require 'json'
    require 'faraday'
rescue LoadError
    raise 'This module requires the `json` and `faraday` gems.'
end

class PuppetX::Pingdom::Client
    @@api_host = 'https://api.pingdom.com'
    @@api_base = '/api/2.1'
    @@endpoint = {
        :checks  => "#{@@api_base}/checks",
        :teams   => "#{@@api_base}/teams",
        :users   => "#{@@api_base}/users"
    }

    def initialize(account_email, user_email, password, appkey, logging=nil)
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
        @api.basic_auth(user_email, password)
        @api.headers['App-Key'] = appkey
        @api.headers['Account-Email'] = account_email
    end

    #
    # Checks API
    #
    def checks(filter_tags=[])
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
        params.update :tags => params[:tags].join(',')
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
        params.update :tags => params[:tags].join(',')
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

    #
    # Teams API
    #
    def teams
        # list of teams
        @teams ||= begin
            response = @api.get @@endpoint[:teams]
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['teams']
        end
    end

    def create_team(params)
        response = @api.post @@endpoint[:teams], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        body['team']
    end

    def find_team(name)
        # returns team or nil
        teams.select { |team| team['name'] == name } [0]
    end

    def modify_team(team, params)
        response = @api.put "#{@@endpoint[:teams]}/#{team['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_team(team)
        response = @api.delete @@endpoint[:teams], {
            :delteamids => team['id'].to_s
        }
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    #
    # Users API
    #
    def users
        # list of users
        @users ||= begin
            response = @api.get @@endpoint[:users]
            body = JSON.parse(response.body)
            raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
            body['users']
        end
    end

    def select_users(values, search='id')
        # returns list of users or nil
        users.select { |user| values.include? user[search] }
    end

    def create_user(params)
        contacts = params.fetch(:contact_targets, nil)
        params.delete :contact_targets
        response = @api.post @@endpoint[:users], params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
        user = body['user']
        contacts.each do |contact|
            response = @api.post "#{@@endpoint[:users]}/#{user['id']}", contact
            contact = JSON.parse(response.body)
            raise "Error(#{__method__}): #{contact['error']['errormessage']}" unless response.success?
        end
        user
    end

    def find_user(name)
        # returns user or nil
        users.select { |user| user['name'] == name } [0]
    end

    def modify_user(user, params)
        contacts = params.fetch(:contact_targets, [])
        old_contacts = params.fetch(:old_contact_targets, [])
        params.delete :contact_targets
        params.delete :old_contact_targets
        response = @api.put "#{@@endpoint[:users]}/#{user['id']}", params
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?

        old_contacts.each do |contact|
            delete_contact user, contact if contact.include? 'id'
        end
        contacts.each do |contact|
            create_contact user, contact
        end
        user
    end

    def delete_user(user)
        response = @api.delete "#{@@endpoint[:users]}/#{user['id']}"
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def create_contact(user, contact)
        response = @api.post "#{@@endpoint[:users]}/#{user['id']}", contact
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def modify_contact(user, contact)
        response = @api.put "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}", contact
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end

    def delete_contact(user, contact)
        response = @api.delete "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}"
        body = JSON.parse(response.body)
        raise "Error(#{__method__}): #{body['error']['errormessage']}" unless response.success?
    end
end
