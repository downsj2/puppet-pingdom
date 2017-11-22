require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

require 'uri'

Puppet::Type.type(:pingdom_check).provide(:httpcustom, :parent => :check) do
    has_features :port, :url, :auth, :encryption, :additionalurls

    def additionalurls
        begin
            @current['type']['httpcustom']['additionalurls']
        rescue
            :absent
        end
    end

    def additionalurls=(value)
        @property_hash[:additionalurls] = value.join(';') if value.respond_to? :join
    end

    def auth
        begin
            username = @current['type']['httpcustom']['username']
            password = @current['type']['httpcustom']['password']
            "#{username}:#{password}"
        rescue
            :absent
        end
    end

    def encryption
        begin
            @current['type']['httpcustom']['encryption']
        rescue
            :absent
        end
    end

    def port
        begin
            @current['type']['httpcustom']['port']
        rescue
            :absent
        end
    end

    def url
        begin
            @current['type']['httpcustom']['url']
        rescue
            :absent
        end
    end

    accessorize
end