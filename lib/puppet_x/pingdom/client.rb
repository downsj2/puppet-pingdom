require 'json'
require 'faraday'

module PuppetX; end
module PuppetX::Pingdom; end

class PuppetX::Pingdom::Client
    @@api_host = 'https://api.pingdom.com'
    @@api_base = '/api/2.1'
    @@endpoint = {
        :checks => "#{@@api_base}/checks",
        :teams  => "#{@@api_base}/teams",
        :users  => "#{@@api_base}/users"
    }

    def initialize(username, password, appkey)
        @conn = Faraday.new(:url => @@api_host)
        @conn.basic_auth(username, password)
        @conn.headers['App-Key'] = appkey
    end

    #
    # checks API
    #
    def checks
        # list of checks with simple memoization
        @checks ||= begin
            result = @conn.get @@endpoint[:checks]
            res = JSON.parse(result.body)
            raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
            @checks = res['checks']
        end
        @checks
    end

    def create_check(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceChecks for params
        defaults = {
            :type => 'http',
            :name => name,
            :paused => true
        }
        defaults.update(params)
        result = @conn.post @@endpoint[:checks], defaults
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res['check']
    end

    def find_check(name)
        # returns check or nil
        checks.select { |check| check['name'] == name } [0]
    end

    def modify_check(check, params)
        result = @conn.put "#{@@endpoint[:checks]}/#{check['id']}", params
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res
    end

    def delete_check(check)
        result = @conn.delete @@endpoint[:checks], {
            :delcheckids => check['id'].to_s
        }
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res
    end

    #
    # teams API (UNTESTED)
    #
    def teams
        # list of teams with simple memoization
        @teams ||= begin
            result = @conn.get @@endpoint[:teams]
            res = JSON.parse(result.body)
            raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
            @teams = res['teams']
        end
        @teams
    end

    def create_team(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceTeam for params
        defaults = {
            :name => name
        }
        defaults.update(params)
        result = @conn.post @@endpoint[:teams], defaults
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res['team']
    end

    def find_team(name)
        # returns team or nil
        teams.select { |team| team['name'] == name } [0]
    end

    def modify_team(team, params)
        result = @conn.put "#{@@endpoint[:teams]}/#{team['id']}", params
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res
    end

    def delete_team(team)
        result = @conn.delete @@endpoint[:teams], {
            :delteamids => team['id'].to_s
        }
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res
    end

    #
    # users API (UNTESTED)
    #
    def users
        # list of users with simple memoization
        @users ||= begin
            result = @conn.get @@endpoint[:users]
            res = JSON.parse(result.body)
            raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
            @users = res['users']
        end
        @users
    end

    def create_user(name, params)
        # see https://www.pingdom.com/resources/api/2.1#ResourceUsers for params
        defaults = {
            :name => name
        }
        defaults.update(params)
        result = @conn.post @@endpoint[:users], defaults
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res['user']
    end

    def find_user(name)
        # returns user or nil
        users.select { |user| user['name'] == name } [0]
    end

    def modify_user(user, params)
        result = @conn.put "#{@@endpoint[:users]}/#{user['id']}", params
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res
    end

    def delete_user(user)
        result = @conn.delete @@endpoint[:users], {
            :deluserids => user['id'].to_s
        }
        res = JSON.parse(result.body)
        raise "#{__method__}: #{res['error']['errormessage']}" unless result.success?
        res
    end
end
