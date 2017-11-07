Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :host, :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :additionalurls, :postdata, :requestheaders

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

    def port
        begin
            @check['type']['httpcustom']['port']
        rescue => exception
            :absent
        end
    end

    def requestheaders
        begin
            headers = @check['type']['httpcustom']['requestheaders']
            headers.split(',')
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