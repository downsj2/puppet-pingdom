require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    def port
        begin
            @current['type']['udp']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @current['type']['udp']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    def stringtosend
        begin
            @current['type']['udp']['stringtosend']
        rescue => exception
            :absent
        end
    end

    accessorize
end