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
            :host           => @property_hash[:host],
            :url            => @property_hash[:url],
            :encryption     => @property_hash[:encryption],
            :port           => @property_hash[:port],
            :auth           => @property_hash[:auth],
            :additionalurls => @property_hash[:additionalurls]
        })
    end
end