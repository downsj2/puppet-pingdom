require 'json'
require 'faraday'

class PingdomClient
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
        if @checks.nil? then
            result = @conn.get @@endpoint[:checks]
            raise 'checks API error' unless result.status == 200
            res = JSON.parse(result.body)
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
        raise "create_check: #{res['error']['errormessage']}" unless result.success?
        res['check']
    end

    def find_check(name)
        # returns check or nil
        checks.select { |check| check['name'] == name } [0]
    end

    def modify_check(check, params)
        result = @conn.put "#{@@endpoint[:checks]}/#{check['id']}", params
        res = JSON.parse(result.body)
        raise "modify_check: #{res['error']['errormessage']}" unless result.success?
        res
    end

    def delete_check(check)
        result = @conn.delete @@endpoint[:checks], {
            :delcheckids => check['id'].to_s
        }
        res = JSON.parse(result.body)
        raise "delete_check: #{res['error']['errormessage']}" unless result.success?
        res
    end

    #
    # teams API (UNTESTED)
    #
    def teams
        # list of teams with simple memoization
        if @teams.nil? then
            result = @conn.get @@endpoint[:teams]
            res = JSON.parse(result.body)
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
        res['team']
    end

    def find_team(name)
        # returns team or nil
        teams.select { |team| team['name'] == name } [0]
    end

    def modify_team(team, params)
        result = @conn.put "#{@@endpoint[:teams]}/#{team['id']}", params
        JSON.parse(result.body)
    end

    def delete_team(team)
        result = @conn.delete @@endpoint[:teams], {
            :delteamids => team['id'].to_s
        }
        JSON.parse(result.body)
    end

    #
    # users API (UNTESTED)
    #
    def users
        # list of users with simple memoization
        if @users.nil? then
            result = @conn.get @@endpoint[:users]
            res = JSON.parse(result.body)
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
        res['user']
    end

    def find_user(name)
        # returns user or nil
        users.select { |user| user['name'] == name } [0]
    end

    def modify_user(user, params)
        result = @conn.put "#{@@endpoint[:users]}/#{user['id']}", params
        JSON.parse(result.body)
    end

    def delete_user(user)
        result = @conn.delete @@endpoint[:users], {
            :deluserids => user['id'].to_s
        }
        JSON.parse(result.body)
    end
end

Puppet::Type.type(:pingdom).provide(:http) do
    has_feature :http

    mk_resource_methods

    def exists?
        if @client.nil? then
            @client = PingdomClient.new(
                @resource[:username],
                @resource[:password],
                @resource[:appkey]
            )
        end
        @client.find_check @resource[:name]
    end

    def create
        if @client.nil? then
            @client = PingdomClient.new(
                @resource[:username],
                @resource[:password],
                @resource[:appkey]
            )
        end
        @client.create_check @resource[:name], {
            :type => 'http',
            :name => @resource[:name],
            :host => @resource[:host],
            :url  => @resource[:url]
        }
    end

    def destroy
        if @client.nil? then
            @client = PingdomClient.new(
                @resource[:username],
                @resource[:password],
                @resource[:appkey]
            )
        end
        check = @client.find_check @resource[:name]
        @client.delete_check check
    end
end