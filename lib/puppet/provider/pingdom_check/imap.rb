require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:imap, :parent => :check) do
    has_features :encryption, :port, :stringtoexpect

    def encryption
        begin
            @current['type']['imap']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @current['type']['imap']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @current['type']['imap']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end