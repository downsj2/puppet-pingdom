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
                make_methods :get, :post, :put, :delete
            end

            def basic_auth(username, password)
                @basic_auth = [username, password]
            end

            def headers(params)
                @headers = params
            end

            private

            def request(method, path, params={})
                uri = encode_uri path, params
                request = Net::HTTP.const_get(method.capitalize).new uri
                request.basic_auth *@basic_auth if @basic_auth
                @headers.each do |k, v|
                    request[k] = v
                    @logger.debug "#{k}: #{v}"
                end
                response = @http.request request
                data = JSON.parse response.body
                @logger.info "#{response.code} #{method.upcase} #{uri}"
                @logger.debug data
                return data if response.code == '200'
                raise "Error #{response.code}: #{data['statusdesc']}"
            end

            def make_methods(*verbs)
                verbs.each do |v|
                    # this call is a bit funky because we're called from
                    # `initialize` and `define_method` isn't within scope.
                    self.class.send(:define_method, v) do |path, params={}|
                        request v, path, params
                    end
                end
            end

            def encode_uri(path, params)
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
                :checks => "#{@@api_base}/checks",
                :teams  => "#{@@api_base}/teams",
                :users  => "#{@@api_base}/users"
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
                    response = @api.get @@endpoint[:checks], {
                        :include_tags => true,
                        :tags => filter_tags.join(',')
                    }
                    response['checks']
                end
            end

            def get_check_details(check)
                response = @api.get "#{@@endpoint[:checks]}/#{check['id']}", {
                    :include_teams => true
                }
                response['check']
            end

            def create_check(params)
                response = @api.post @@endpoint[:checks], params
                response['check']
            end

            def find_check(name, filter_tags)
                # returns check or nil
                check = checks(filter_tags).select { |check| check['name'] == name } [0]
                get_check_details(check) if check
            end

            def modify_check(check, params)
                @api.put "#{@@endpoint[:checks]}/#{check['id']}", params
            end

            def delete_check(check)
                response = @api.delete @@endpoint[:checks], {
                    :delcheckids => check['id'].to_s
                }
            end

            #
            # Teams API
            #
            def teams
                # list of teams
                @teams ||= begin
                    response = @api.get @@endpoint[:teams]
                    response['teams']
                end
            end

            def select_teams(values, search='id')
                # returns list of teams or nil
                teams.select { |team| values.include? team[search] }
            end

            def create_team(params)
                response = @api.post @@endpoint[:teams], params
                response['team']
            end

            def find_team(name)
                # returns team or nil
                teams.select { |team| team['name'] == name } [0]
            end

            def modify_team(team, params)
                @api.put "#{@@endpoint[:teams]}/#{team['id']}", params
            end

            def delete_team(team)
                @api.delete "#{@@endpoint[:teams]}/#{team['id']}"
            end

            #
            # Users API
            #
            def users
                # list of users
                @users ||= begin
                    response = @api.get @@endpoint[:users]
                    response['users']
                end
            end

            def select_users(values, search='id')
                # returns list of users or nil
                users.select { |user| values.include? user[search] }
            end

            def create_user(params)
                # params should only contain :name as of 2.1
                response = @api.post @@endpoint[:users], params
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
                response = @api.put "#{@@endpoint[:users]}/#{user['id']}", params

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
                @api.delete "#{@@endpoint[:users]}/#{user['id']}"
            end

            def create_contact_target(user, contact)
                @api.post "#{@@endpoint[:users]}/#{user['id']}", contact
            end

            def modify_contact_target(user, contact)
                @api.put "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}", contact
            end

            def delete_contact_target(user, contact)
                @api.delete "#{@@endpoint[:users]}/#{user['id']}/#{contact['id']}"
            end

            # #
            # # Integrations API (TBD)
            # #
            # def integrations
            #     # list of integrations
            #     @integrations ||= begin
            #         response = @api.get @@endpoint[:integrations]
            #         response['integrations']
            #     end
            # end

            # def select_integrations(values, search='id')
            #     # returns list of integrations or nil
            #     integrations.select { |integration| values.include? integration[search] }
            # end

            # def create_integration(params)
            #     response = @api.post @@endpoint[:integrations], params
            #     response['integration']
            # end

            # def find_integration(name)
            #     # returns integration or nil
            #     integrations.select { |integration| integration['name'] == name } [0]
            # end

            # def modify_integration(integration, params)
            #     @api.put "#{@@endpoint[:integrations]}/#{integration['id']}", params
            # end

            # def delete_integration(integration)
            #     @api.delete "#{@@endpoint[:integrations]}/#{integration['id']}"
            # end
        end
    end
end