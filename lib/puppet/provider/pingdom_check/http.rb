require 'uri'

Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check_base) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders
    defaultfor :feature => :posix

    def auth
        begin
            username = @check['type'][self.name]['username']
            password = @check['type'][self.name]['password']
            "#{username}:#{password}"
        rescue => exception
            :absent
        end
    end

    def encryption
        begin
            @check['type'][self.name]['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type'][self.name]['port']
        rescue => exception
            :absent
        end
    end

    def postdata
        begin
            URI.decode_www_form(@check['type'][self.name]['postdata']).to_h
        rescue => exception
            :absent
        end
    end

    def postdata=(value)
        @property_hash[:postdata] = URI.encode_www_form(value)
    end

    def requestheaders
        begin
            headers = @check['type'][self.name]['requestheaders']
            headers.delete_if { |key, value| key == 'User-Agent' }
        rescue => exception
            :absent
        end
    end

    def requestheaders=(value)
        i = 0
        value.each do |k, v|
            @property_hash["requestheader#{i += 1}"] = "#{k}:#{v}"
        end
    end

    def shouldcontain
        begin
            @check['type'][self.name]['shouldcontain']
        rescue => exception
            :absent
        end
    end

    def shouldnotcontain
        begin
            @check['type'][self.name]['shouldnotcontain']
        rescue => exception
            :absent
        end
    end

    def url
        begin
            @check['type'][self.name]['url']
        rescue => exception
            :absent
        end
    end

    accessorize
end