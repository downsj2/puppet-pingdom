Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :host, :port, :url, :auth, :encryption, :additionalurls

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

    accessorize
end