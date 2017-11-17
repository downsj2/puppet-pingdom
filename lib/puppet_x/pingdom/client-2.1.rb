#
# Thin wrapper around Pingdom API.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

require 'json'

module PuppetX
    module PuppetX::Pingdom
        class PuppetX::Pingdom::Http
            require 'net/https'

            def initialize(host, loglevel=nil)
                uri = URI.parse(host)
                @http = Net::HTTP.new(uri.host, 443)
                @http.use_ssl = true
                @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
                @headers = {}
                @basic_auth = nil
                enable_logging if loglevel
            end

            def basic_auth(username, password)
                @basic_auth = [username, password]
            end

            def headers(params)
                @headers = params
            end

            def request(method, path, params={})
                full_path = encode_path_params path, params
                request = Net::HTTP.const_get(method.capitalize).new full_path
                request.basic_auth *@basic_auth if @basic_auth
                @headers.each do |k, v|
                    request[k] = v
                end
                response = @http.request request
                raise "Got an HTTP error: #{response.code}" unless [200].include? response.code.to_i
                response
            end

            private

            def encode_path_params(path, params)
                encoded = URI.encode_www_form params
                [path, encoded].join '?'
            end

            def enable_logging
                @http.set_debug_output $stderr
            end
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
                @api = PuppetX::Pingdom::Http.new @@api_host, logging
                @api.basic_auth(user_email, password)
                @api.headers({
                    'App-Key' => appkey,
                    'Account-Email' => account_email
                })
            end

            #
            # Checks API
            #
            def checks(filter_tags=[])
                # list of checks
                @checks ||= begin
                    params = { :include_tags => true, :tags => filter_tags.join(',') }
                    response = @api.request :get, @@endpoint[:checks], params
                    body = JSON.parse(response.body)
                    body['checks']
                end
            end

            def get_check_details(check)
                response = @api.request :get, "#{@@endpoint[:checks]}/#{check['id']}"
                body = JSON.parse(response.body)
                body['check']
            end

            def create_check(params)
                response = @api.request :post, @@endpoint[:checks], params
                body = JSON.parse(response.body)
                body['check']
            end

            def find_check(name, filter_tags)
                # returns check or nil
                check = checks(filter_tags).select { |check| check['name'] == name } [0]
                get_check_details(check) if check
            end

            def modify_check(check, params)
                response = @api.request :put, "#{@@endpoint[:checks]}/#{check['id']}", params
                body = JSON.parse(response.body)
            end

            def delete_check(check)
                response = @api.request :delete, @@endpoint[:checks], {
                    :delcheckids => check['id'].to_s
                }
                body = JSON.parse(response.body)
            end

            #
            # Teams API
            #
            def teams
                # list of teams
                @teams ||= begin
                    response = @api.request :get, @@endpoint[:teams]
                    body = JSON.parse(response.body)
                    body['teams']
                end
            end

            def create_team(params)
                response = @api.request :post, @@endpoint[:teams], params
                body = JSON.parse(response.body)
                body['team']
            end

            def find_team(name)
                # returns team or nil
                teams.select { |team| team['name'] == name } [0]
            end

            def modify_team(team, params)
                response = @api.request :put, "#{@@endpoint[:teams]}/#{team['id']}", params
                body = JSON.parse(response.body)
            end

            def delete_team(team)
                response = @api.request :delete, @@endpoint[:teams], {
                    :delteamids => team['id'].to_s
                }
                body = JSON.parse(response.body)
            end

            #
            # Users API
            #
            def users
                # list of users
                @users ||= begin
                    response = @api.request :get, @@endpoint[:users]
                    body = JSON.parse(response.body)
                    body['users']
                end
            end

            def select_users(values, search='id')
                # returns list of users or nil
                users.select { |user| values.include? user[search] }
            end

            def create_user(params)
                # params should only contain :name as of 2.1
                response = @api.request :post, @@endpoint[:users], params
                body = JSON.parse(response.body)
                body['user']
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
                response = @api.request :put, "#{@@endpoint[:users]}/#{user['id']}", params
                body = JSON.parse(response.body)

                if !contacts.empty?
                    old_contacts.each do |contact|
                        delete_contact_target user, contact if contact.include? 'id'
                    end
                    contacts.each do |contact|
                        create_contact_target user, contact
                    end
                end
                user
            end

            def delete_user(user)
                response = @api.request :delete, "#{@@endpoint[:users]}/#{user['id']}"
                body = JSON.parse(response.body)
            end

            def create_contact_target(user, contact)
                response = @api.request :post, "#{@@endpoint[:users]}/#{user['id']}", contact
                body = JSON.parse(response.body)
            end

            def modify_contact_target(user, contact)
                response = @api.request :put, "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}", contact
                body = JSON.parse(response.body)
            end

            def delete_contact_target(user, contact)
                response = @api.request :delete, "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}"
                body = JSON.parse(response.body)
            end
        end
    end
end