require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:udp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    def port
        begin
            @current['type']['udp']['port']
        rescue
            :absent
        end
    end

    def stringtoexpect
        begin
            @current['type']['udp']['stringtoexpect']
        rescue
            :absent
        end
    end

    def stringtosend
        begin
            @current['type']['udp']['stringtosend']
        rescue
            :absent
        end
    end

    accessorize
end