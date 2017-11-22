require File.expand_path(File.join(File.dirname(__FILE__), 'check.rb'))

Puppet::Type.type(:pingdom_check).provide(:smtp, :parent => :check) do
    has_features :port, :auth, :stringtoexpect, :encryption

    def auth
        begin
            username = @current['type']['smtp']['username']
            password = @current['type']['smtp']['password']
            "#{username}:#{password}"
        rescue => exception
            :absent
        end
    end

    def encryption
        begin
            @current['type']['smtp']['encryption']
        rescue => exception
            :absent
        end
    end

    def port
        begin
            @current['type']['smtp']['port']
        rescue => exception
            :absent
        end
    end

    def stringtoexpect
        begin
            @current['type']['smtp']['stringtoexpect']
        rescue => exception
            :absent
        end
    end

    accessorize
end