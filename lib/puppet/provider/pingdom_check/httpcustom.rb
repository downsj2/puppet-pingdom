require 'uri'

Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders, :additionalurls

    def auth
        begin
            @check['type']['httpcustom']['auth']
        rescue => exception
            :absent
        end
    end

    def additionalurls
        begin
            urls = @check['type']['httpcustom']['additionalurls']
            urls.split(';')
        rescue => exception
            :absent
        end
    end

    def additionalurls=(value)
        @property_hash[:additionalurls] = value.join(';') if value.respond_to? :join
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

    def postdata
        begin
            URI.decode_www_form(@check['type']['http']['postdata']).to_h
        rescue => exception
            :absent
        end
    end

    def postdata=(value)
        @property_hash[:postdata] = URI.encode_www_form(value)
    end

    def requestheaders
        begin
            s = @check['type']['httpcustom']['requestheaders']
            s.split(',')
        rescue => exception
            :absent
        end
    end

    def shouldcontain
        begin
            @check['type']['httpcustom']['shouldcontain']
        rescue => exception
            :absent
        end
    end

    def shouldnotcontain
        begin
            @check['type']['httpcustom']['shouldnotcontain']
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