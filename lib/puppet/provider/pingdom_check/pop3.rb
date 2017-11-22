require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:pop3, :parent => :check) do
    has_features :port, :stringtoexpect, :encryption

    def encryption
        begin
            @current['type']['pop3']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @current['type']['pop3']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @current['type']['pop3']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end