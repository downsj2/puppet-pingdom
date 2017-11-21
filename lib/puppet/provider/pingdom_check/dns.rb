require File.expand_path(File.join(File.dirname(__FILE__), 'check_base.rb'))

Puppet::Type.type(:pingdom_check).provide(:dns, :parent => :check_base) do
    has_features :expectedip, :nameserver

    def expectedip
        begin
            @check['type']['dns']['expectedip']
        rescue => exception
            :absent
        end
    end

    def nameserver
        begin
            @check['type']['dns']['nameserver']
        rescue => exception
            :absent
        end
    end

    accessorize :@check
end