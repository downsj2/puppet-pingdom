require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check) do
    has_features :expectedip, :nameserver

    def expectedip
        begin
            @current['type']['dns']['expectedip']
        rescue
            :absent
        end
    end

    def nameserver
        begin
            @current['type']['dns']['nameserver']
        rescue
            :absent
        end
    end

    accessorize
end