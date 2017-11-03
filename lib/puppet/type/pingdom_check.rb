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

    newproperty(:paused) do
        desc 'Paused [boolean]'
        newvalues(:true, :false)
        defaultto :false
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

    newproperty(:notifyagainevery) do
        desc 'Notify again every n result. 0 means that no extra notifications will be sent [integer]'
        defaultto 0

        def insync?(is)
            is.to_s == should.to_s
        end
    end

    newproperty(:notifywhenbackup) do
        desc 'Notify when back up again [boolean]'
        newvalues(:true, :false)
        defaultto :false
    end

    newproperty(:ipv6) do
        desc %w(
        Use ipv6 instead of ipv4, if an IP address is provided as host this
        will be overrided by the IP address version [boolean])
        newvalues(:true, :false)
        defaultto :false
    end

    newproperty(:responsetime_threshold) do
        desc 'Triggers a down alert if the response time exceeds threshold specified in ms [integer]'
        defaultto 30000

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
    feature :http, "HTTP check API"
    newproperty(:host, :required_features=>:http) do
        desc 'HTTP host to check [string]'
    end

    newproperty(:url, :required_features=>:http) do
        desc 'URL to check [string]'
    end
end