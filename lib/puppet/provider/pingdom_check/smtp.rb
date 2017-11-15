require File.expand_path(File.join(File.dirname(__FILE__), '.', 'check_base.rb'))

Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check_base) do
    has_features :port, :auth, :stringtoexpect, :encryption

    def auth
        begin
            username = @check['type']['smtp']['username']
            password = @check['type']['smtp']['password']
            "#{username}:#{password}"
        rescue => exception
            :absent
        end
    end

    def encryption
        begin
            @check['type']['smtp']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @check['type']['smtp']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @check['type']['smtp']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end