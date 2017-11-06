Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :host, :port, :url, :auth, :encryption, :additionalurls

    def additionalurls
        begin
            @check['type']['httpcustom']['additionalurls']
        rescue => exception
            :absent
        end
        @check.fetch('additionalurls', :absent)
    end

    def additionalurls=(value)
        @property_hash[:additionalurls] = value
    end
end