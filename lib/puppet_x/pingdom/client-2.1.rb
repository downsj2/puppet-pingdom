#
# Thin wrapper around Pingdom API.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

module PuppetX
    module PuppetX::Pingdom
        class PuppetX::Pingdom::Http
            require 'net/https'
            require 'json'

            def initialize(host, log_level=:error)
                uri = URI.parse(host)
                @http = Net::HTTP.new(uri.host, 443)
                @http.use_ssl = true
                @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
                @headers = {}
                @basic_auth = nil
                enable_logging log_level.to_s
            end

            def basic_auth(username, password)
                @basic_auth = [username, password]
            end

            def headers(params)
                @headers = params
            end

            def request(method, path, params={})
                uri = encode_path_params path, params
                request = Net::HTTP.const_get(method.capitalize).new uri
                request.basic_auth *@basic_auth if @basic_auth
                @headers.each do |k, v|
                    request[k] = v
                    @logger.debug "#{k}: #{v}"
                end
                response = @http.request request
                @logger.info "#{response.code} #{method.upcase} #{uri}"
                @logger.debug response.body
                raise "Got an HTTP error: #{response.code}" unless response.code == '200'
                JSON.parse(response.body)
            end

            private

            def encode_path_params(path, params)
                encoded = URI.encode_www_form params
                [path, encoded].join '?'
            end

            def enable_logging(level)
                require 'logger'
                @logger = Logger.new $stderr
                @logger.level = Logger.const_get(level.upcase)
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

            def initialize(account_email, user_email, password, appkey, log_level=:error)
                @api = PuppetX::Pingdom::Http.new @@api_host, log_level
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
                    response['checks']
                end
            end

            def get_check_details(check)
                response = @api.request :get, "#{@@endpoint[:checks]}/#{check['id']}"
                response['check']
            end

            def create_check(params)
                response = @api.request :post, @@endpoint[:checks], params
                response['check']
            end

            def find_check(name, filter_tags)
                # returns check or nil
                check = checks(filter_tags).select { |check| check['name'] == name } [0]
                get_check_details(check) if check
            end

            def modify_check(check, params)
                @api.request :put, "#{@@endpoint[:checks]}/#{check['id']}", params
            end

            def delete_check(check)
                response = @api.request :delete, @@endpoint[:checks], {
                    :delcheckids => check['id'].to_s
                }
            end

            #
            # Teams API
            #
            def teams
                # list of teams
                @teams ||= begin
                    response = @api.request :get, @@endpoint[:teams]
                    response['teams']
                end
            end

            def create_team(params)
                response = @api.request :post, @@endpoint[:teams], params
                response['team']
            end

            def find_team(name)
                # returns team or nil
                teams.select { |team| team['name'] == name } [0]
            end

            def modify_team(team, params)
                @api.request :put, "#{@@endpoint[:teams]}/#{team['id']}", params
            end

            def delete_team(team)
                @api.request :delete, @@endpoint[:teams], {
                    :delteamids => team['id'].to_s
                }
            end

            #
            # Users API
            #
            def users
                # list of users
                @users ||= begin
                    response = @api.request :get, @@endpoint[:users]
                    response['users']
                end
            end

            def select_users(values, search='id')
                # returns list of users or nil
                users.select { |user| values.include? user[search] }
            end

            def create_user(params)
                # params should only contain :name as of 2.1
                response = @api.request :post, @@endpoint[:users], params
                response['user']
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
                @api.request :delete, "#{@@endpoint[:users]}/#{user['id']}"
            end

            def create_contact_target(user, contact)
                @api.request :post, "#{@@endpoint[:users]}/#{user['id']}", contact
            end

            def modify_contact_target(user, contact)
                @api.request :put, "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}", contact
            end

            def delete_contact_target(user, contact)
                @api.request :delete, "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}"
            end
        end
    end
end