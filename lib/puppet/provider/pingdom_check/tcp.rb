require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:tcp, :parent => :check) do
    has_features :port, :stringtosend, :stringtoexpect

    def port
        begin
            @current['type']['tcp']['port']
        rescue
            :absent
        end
    end

    def stringtoexpect
        begin
            @current['type']['tcp']['stringtoexpect']
        rescue
            :absent
        end
    end

    def stringtosend
        begin
            @current['type']['tcp']['stringtosend']
        rescue
            :absent
        end
    end

    accessorize
end