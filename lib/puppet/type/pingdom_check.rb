Puppet::Type.newtype(:pingdom_check) do
    @doc = 'Pingdom API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the check.'
    end

    newparam(:username) do
        desc 'API username [string]'
    end

    newparam(:password) do
        desc 'API password [string]'
    end

    newparam(:appkey) do
        desc 'API app key [string]'
    end

    newparam(:debug) do
        desc 'Debug level for module [integer]'
        defaultto 0
    end

    newproperty(:paused) do
        desc 'Paused [boolean]'
        newvalues(:true, :false)
        defaultto :false

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:integrationids, :array_matching=>:all) do
        desc 'Integration identifiers [list of integers]'
        defaultto []

        def insync?(is)
            if is == :absent
                return should.empty?
            end
            isarr = is.split(',')
            isarr.sort == should.sort
        end
    end

    newproperty(:ipv6) do
        desc %w(
        Use ipv6 instead of ipv4, if an IP address is provided as host this
        will be overrided by the IP address version [boolean])
        newvalues(:true, :false)
        defaultto :false

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:notifyagainevery) do
        desc 'Notify again every n result [integer]'
        defaultto 0

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:notifywhenbackup) do
        desc 'Notify when back up again [boolean]'
        newvalues(:true, :false)
        defaultto :false

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:probe_filters, :array_matching=>:all) do
        desc %w(
        Filters used for probe selections. Overwrites previous filters for check.
        To remove all filters from a check, use an empty value [hash])
        defaultto []

        def insync?(is)
            if is == :absent
                return should.empty?
            end
            isarr = is.split(',')
            isarr.sort == should.sort
        end
    end

    newproperty(:resolution) do
        desc 'Check resolution [integer (1, 5, 15, 30, 60)]'
        newvalues(1, 5, 15, 30, 60)
        defaultto 5

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:sendnotificationwhendown) do
        desc 'Send notification when down n times [integer]'
        defaultto 2

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:tags, :array_matching=>:all) do
        desc 'Check tags [list of strings]'
        defaultto []

        def insync?(is)
            if is == :absent
                return should.empty?
            end
            is.sort == should.sort
        end
    end

    newproperty(:teamids, :array_matching=>:all) do
        desc 'Teams to alert [list of integers]'
        defaultto []

        def insync?(is)
            if is == :absent
                return should.empty?
            end
            isarr = is.split(',')
            isarr.sort == should.sort
        end
    end

    newproperty(:userids, :array_matching=>:all) do
        desc 'User identifiers [list of integers]'
        defaultto []

        def insync?(is)
            if is == :absent
                return should.empty?
            end
            isarr = is.split(',')
            isarr.sort == should.sort
        end
    end

    #
    # provider-specific properties
    #
    feature :dns,        'DNS check API'
    feature :http,       'HTTP check API'
    feature :httpcustom, 'HTTP custom check API'
    feature :imap,       'IMAP check API'
    feature :ping,       'ICMP check API'
    feature :pop3,       'POP3 check API'
    feature :smtp,       'SMTP check API'
    feature :tcp,        'TCP check API'
    feature :udp,        'UDP check API'

    # :additionalurls, :auth, :encryption, :expectedip, :host, :hostname,
    # :nameserver, :port, :postdata, :requestheaders, :shouldcontain,
    # :shouldnotcontain, :stringtoexpect, :stringtosend, :url

    newproperty(:additionalurls, :required_features => :httpcustom) do
        desc 'Colon-separated list of addidional URLs with hostname included [string]'
    end

    newproperty(:auth, :required_features => [:http, :smtp]) do
        desc 'Credentials in the form "username:password" for target HTTP authentication [string]'
    end

    newproperty(:encryption, :required_features => [:http, :smtp, :pop3, :imap]) do
        desc 'Connection encryption [boolean]'
    end

    newproperty(:expectedip, :required_features => :dns) do
        desc 'Expected IP address [string]'
    end

    newproperty(:host, :required_features => [:http, :ping]) do
        desc 'HTTP hostname or IP to check [string]'
    end

    newproperty(:hostname, :required_features => :dns) do
        desc 'DNS hostname to check [string]'
    end

    newproperty(:nameserver, :required_features => :dns) do
        desc 'Nameserver [string]'
    end

    newproperty(:port, :required_features => [:tcp, :udp, :http, :smtp, :pop3, :imap]) do
        desc 'Target port [integer]'
    end

    newproperty(:postdata, :required_features => :http) do
        desc %w(Data that should be posted to the web page, for example
                submission data for a sign-up or login form. The data
                needs to be formatted in the same way as a web browser
                would send it to the web server [string])
    end

    newproperty(:requestheaders, :required_features => :http, :array_matching=>:all) do
        desc %w(Custom HTTP headers. [hash]
                For example: { 'My-Header' => 'value', 'Other-Header' => '100' })
        defaultto {}
    end

    newproperty(:shouldcontain, :required_features => :http) do
        desc 'Target site should contain this string [string]'
    end

    newproperty(:shouldnotcontain, :required_features => :http) do
        desc %w(Target site should NOT contain this string. If shouldcontain
                is also set, this parameter is not allowed [string])
    end

    newproperty(:stringtoexpect, :required_features => [:tcp, :udp, :smtp, :pop3, :imap]) do
        desc 'String to expect in response [string]'
    end

    newproperty(:stringtosend, :required_features => [:tcp, :udp]) do
        desc 'String to send [string]'
    end

    newproperty(:url, :required_features => :http) do
        desc 'URL to check [string]'
    end
end