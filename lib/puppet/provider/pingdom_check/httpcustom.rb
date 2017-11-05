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
            :host           => fetch(:host),
            :url            => fetch(:url),
            :encryption     => fetch(:encryption),
            :port           => fetch(:port),
            :auth           => fetch(:auth),
            :additionalurls => fetch(:additionalurls)
        })
    end
end