require 'uri'

Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :http) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders, :additionalurls

    def additionalurls
        begin
            @check['type'][self.name]['additionalurls']
        rescue => exception
            :absent
        end
    end

    def additionalurls=(value)
        @property_hash[:additionalurls] = value.join(';') if value.respond_to? :join
    end

    accessorize
end