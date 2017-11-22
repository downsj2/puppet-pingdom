require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

require 'uri'
require 'digest'

Puppet::Type.type(:pingdom_check).provide(:http, :parent => :check) do
    has_features :port, :url, :auth, :encryption, :shouldcontain,
                 :shouldnotcontain, :postdata, :requestheaders
    defaultfor :feature => :posix

    def auth
        begin
            username = @current['type']['http']['username']
            password = @current['type']['http']['password']
            "#{username}:#{password}"
        rescue
            :absent
        end
    end

    def encryption
        begin
            @current['type']['http']['encryption']
        rescue
            :absent
        end
    end

    def port
        begin
            @current['type']['http']['port']
        rescue
            :absent
        end
    end

    def postdata
        begin
            URI.decode_www_form(@current['type']['http']['postdata']).to_h
        rescue
            :absent
        end
    end

    def postdata=(value)
        @property_hash[:postdata] = URI.encode_www_form(value)
    end

    def requestheaders
        begin
            headers = @current['type']['http']['requestheaders']
            headers.delete_if { |key, value| key == 'User-Agent' }
        rescue => exception
            :absent
        end
    end

    def requestheaders=(value)
        i = 0
        value.each do |k, v|
            @property_hash["requestheader#{i += 1}"] = "#{k}:#{v}"
        end
    end

    def shouldcontain
        begin
            @current['type']['http']['shouldcontain']
        rescue => exception
            :absent
        end
    end

    def shouldnotcontain
        begin
            @current['type']['http']['shouldnotcontain']
        rescue => exception
            :absent
        end
    end

    def url
        begin
            @current['type']['http']['url']
        rescue => exception
            :absent
        end
    end

    accessorize
end