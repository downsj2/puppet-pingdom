require 'uri'

Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :check_base) do
    has_features :port, :url, :auth, :encryption, :additionalurls

    def additionalurls
        begin
            @check['type']['httpcustom']['additionalurls']
        rescue => exception
            :absent
        end
    end

    def additionalurls=(value)
        @property_hash[:additionalurls] = value.join(';') if value.respond_to? :join
    end

    def auth
        begin
            username = @check['type']['httpcustom']['username']
            password = @check['type']['httpcustom']['password']
            "#{username}:#{password}"
        rescue => exception
            :absent
        end
    end

    def encryption
        begin
            @check['type']['httpcustom']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type']['httpcustom']['port']
        rescue => exception
            :absent
        end
    end

    def url
        begin
            @check['type']['httpcustom']['url']
        rescue => exception
            :absent
        end
    end

    accessorize
end