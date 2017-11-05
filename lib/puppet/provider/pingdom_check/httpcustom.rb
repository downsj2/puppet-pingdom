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

    def do_apply
        update_or_create :httpcustom, apply_properties({
            :host           => @property_hash.fetch(:host, @resource[:host]),
            :url            => @property_hash.fetch(:url, @resource[:url]),
            :encryption     => @property_hash.fetch(:encryption, @resource[:encryption]),
            :port           => @property_hash.fetch(:port, @resource[:port]),
            :auth           => @property_hash.fetch(:auth, @resource[:auth]),
            :additionalurls => @property_hash.fetch(:additionalurls, @resource[:additionalurls])
        })
    end
end