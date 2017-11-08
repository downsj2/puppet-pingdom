#
# The reason the default value for properties is nil is that
# this indicates that the user is not managing that property.
# Either the property has a sane default on the server side or
# the request will fail.
#
# Author: Cliff Wells <cliff.wells@protonmail.com>
# Homepage: https://github.com/cwells/puppet-pingdom
#

Puppet::Type.newtype(:pingdom_check) do
    @doc = 'Pingdom API'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'The name of the check.'
    end

    newparam(:username) do
        desc 'API username [string].'
    end

    newparam(:password) do
        desc 'API password [string].'
    end

    newparam(:appkey) do
        desc 'API app key [string].'
    end

    newparam(:logging) do
        desc 'Logging level for API requests [String (ERROR, WARN, INFO, DEBUG)]'
        newvalues(:ERROR, :WARN, :INFO, :DEBUG)
        defaultto :ERROR
    end

    newparam(:use_legacy_notifications) do
        desc 'Whether to use legacy notifications [boolean].'
        newvalues(:true, :false)
        defaultto :true
    end

    #
    # common properties
    #
    newproperty(:contacts, :array_matching=>:all) do
        desc 'Contact emails [list of strings].'

        def insync?(is)
            def insync?(is)
                is == :absent ? should.nil? : (should.nil? or is.sort == should.sort)
            end
        end
    end

    newproperty(:host) do
        desc 'HTTP hostname or IP to check [string]'
    end

    newproperty(:integrationids, :array_matching=>:all) do
        desc 'Integration identifiers [list of integers].'

        def insync?(is)
            def insync?(is)
                is == :absent ? should.nil? : (should.nil? or is.sort == should.sort)
            end
        end
    end

    newproperty(:ipv6) do
        desc %q(Use ipv6 instead of ipv4. If an IP address is provided as `host` this
                will be overridden by the IP address type [boolean].)
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:notifyagainevery) do
        desc %q(Notify again every n result [integer].
                Requires use_legacy_notifications => true.)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:notifywhenbackup) do
        desc %q(Notify when back up again [boolean].
                Requires use_legacy_notifications => true.)
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:paused) do
        desc 'Paused [boolean]'
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:probe_filters, :array_matching=>:all) do
        desc %q(Filters used for probe selections. Overwrites previous filters for check.
                To remove all filters from a check, use an empty value.
                Any string of [ 'NA', 'EU', 'APAC'].)

        def insync?(is)
            if is == :absent
                return should.nil?
            end
            should.nil? or is.sort == should.map { |v| 'region: ' + v }
        end
    end

    newproperty(:resolution) do
        desc 'Check resolution [integer (1, 5, 15, 30, 60)].'
        newvalues(1, 5, 15, 30, 60)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:responsetime_threshold) do
        desc %q(Triggers a down alert if the response time exceeds
                threshold specified in ms [integer].)
    end

    newproperty(:sendnotificationwhendown) do
        desc %q(Send notification when down n times [integer].'
                Requires use_legacy_notifications => true.)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:sendtoandroid) do
        desc %q(Send notification to Android [boolean].
                Requires use_legacy_notifications => true.)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:sendtoemail) do
        desc %q(Send alerts as email [boolean].
                Requires use_legacy_notifications => true.)
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:sendtoiphone) do
        desc %q(Send alerts to iPhone [boolean].
                Requires use_legacy_notifications => true.)
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:sendtosms) do
        desc %q(Send alerts to SMS [boolean].
                Requires use_legacy_notifications => true.)
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:sendtotwitter) do
        desc %q(Send alerts to Twitter [boolean].
                Requires use_legacy_notifications => true.)
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:tags, :array_matching=>:all) do
        desc 'Check tags [list of strings].'

        def insync?(is)
            is == :absent ? should.nil? : (should.nil? or is.sort == should.sort)
        end
    end

    #
    # provider-specific properties
    #
    feature :additionalurls,   'Additional URLs to check [list of strings]'
    feature :auth,             'Credentials [string] of the form "username:password"'
    feature :encryption,       'Encryption enabled [boolean]'
    feature :expectedip,       'Expected IP address [string]'
    feature :nameserver,       'DNS nameserver to query [string]'
    feature :port,             'Port [integer]'
    feature :postdata,         'HTTP POST data [urlencoded string]'
    feature :requestheaders,   'HTTP request headers [hash]'
    feature :shouldcontain,    'Response should contain [string]'
    feature :shouldnotcontain, 'Response should not contain [string]'
    feature :stringtoexpect,   'String to expect [string]'
    feature :stringtosend,     'String to send [string]'
    feature :url,              'HTTP URL [string]'

    newproperty(:additionalurls, :array_matching => :all, :required_features => :additionalurls) do
        desc 'List of additional URLs with hostname included [string]'

        def insync?(is)
            is == :absent ? should.nil? : (should.nil? or is.sort == should.sort)
        end
    end

    newproperty(:auth, :required_features => :auth) do
        desc 'Credentials in the form "username:password" for target HTTP authentication [string]'
    end

    newproperty(:encryption, :required_features => :encryption) do
        desc 'Connection encryption [boolean]'
        newvalues(:true, :false)

        def insync?(is)
            should.nil? or is.to_s == should.to_s
        end
    end

    newproperty(:expectedip, :required_features => :expectedip) do
        desc 'Expected IP address [string]'
    end

    newproperty(:nameserver, :required_features => :nameserver) do
        desc 'DNS nameserver [string]'
    end

    newproperty(:port, :required_features => :port) do
        desc 'Target port [integer]'
    end

    newproperty(:postdata, :required_features => :postdata) do
        desc %q(Data that should be posted to the web page, for example
                submission data for a sign-up or login form. The data
                needs to be formatted in the same way as a web browser
                would send it to the web server [Hash])
        def insync?(is)
            should.nil? or is == should
        end
    end

    newproperty(:requestheaders, :required_features => :requestheaders, :array_matching=>:all) do
        desc %q(Custom HTTP headers. [hash]
                For example: { 'My-Header' => 'value', 'Other-Header' => '100' })
    end

    newproperty(:shouldcontain, :required_features => :shouldcontain) do
        desc 'Target site should contain this string [string]'
    end

    newproperty(:shouldnotcontain, :required_features => :shouldnotcontain) do
        desc %q(Target site should NOT contain this string. If shouldcontain
                is also set, this parameter is not allowed [string])
    end

    newproperty(:stringtoexpect, :required_features => :stringtoexpect) do
        desc 'String to expect in response [string]'
    end

    newproperty(:stringtosend, :required_features => :stringtosend) do
        desc 'String to send [string]'
    end

    newproperty(:url, :required_features => :url) do
        desc 'URL to check [string]'
    end
end