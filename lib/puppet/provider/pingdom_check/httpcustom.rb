Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :additionalurls, :postdata, :requestheaders

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
            @check['type']['httpcustom']['postdata']
        rescue => exception
            :absent
        end
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
            s = @check['type']['httpcustom']['shouldcontain']
        rescue => exception
            :absent
        end
    end

    def shouldnotcontain
        begin
            s = @check['type']['httpcustom']['shouldnotcontain']
            s.split(',')
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