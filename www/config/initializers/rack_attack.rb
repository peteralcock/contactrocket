class Rack::Attack
  if Rails.env.production?
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.safelist('allow from localhost') do |req|
      # Requests are allowed if the return value is truthy
      '127.0.0.1' == req.ip || '::1' == req.ip || '192.168.1.100' == req.ip
    end
    # Block suspicious requests for '/etc/password' or wordpress specific paths.
    # After 3 blocked requests in 10 minutes, block all requests from that IP for 5 minutes.
    Rack::Attack.blocklist('fail2ban pentesters') do |req|
      # `filter` returns truthy value if request fails, or if it's from a previously banned IP
      # so the request is blocked
      Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", :maxretry => 1, :findtime => 10.minutes, :bantime => 5.weeks) do
        # The count for the IP is incremented if the return value is truthy
        CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
            req.path.include?('/etc/passwd') ||
            req.path.include?('wp-admin') ||
            req.path.include?('wp-login')
      end
    end

    Rack::Attack.blocklist('allow2ban login scrapers') do |req|
      # `filter` returns false value if request is to your login page (but still
      # increments the count) so request below the limit are not blocked until
      # they hit the limit.  At that point, filter will return true and block.
      Rack::Attack::Allow2Ban.filter(req.ip, :maxretry => 20, :findtime => 1.minute, :bantime => 1.hour) do
        # The count for the IP is incremented if the return value is truthy.
        req.path == '/login' and req.post?
      end
      Rack::Attack::Allow2Ban.filter(req.ip, :maxretry => 20, :findtime => 1.minute, :bantime => 1.hour) do
        # The count for the IP is incremented if the return value is truthy.
        req.path == '/register' and req.post?
      end
      Rack::Attack::Allow2Ban.filter(req.ip, :maxretry => 20, :findtime => 1.minute, :bantime => 1.hour) do
        # The count for the IP is incremented if the return value is truthy.
        req.path == '/users/sign_in' and req.post?
      end
      Rack::Attack::Allow2Ban.filter(req.ip, :maxretry => 20, :findtime => 1.minute, :bantime => 1.hour) do
        # The count for the IP is incremented if the return value is truthy.
        req.path == '/users/sign_up' and req.post?
      end
    end

    Rack::Attack.throttle('req/ip', :limit => 5, :period => 1.second) do |req|
      # If the return value is truthy, the cache key for the return value
      # is incremented and compared with the limit. In this case:
      #   "rack::attack:#{Time.now.to_i/1.second}:req/ip:#{req.ip}"
      #
      # If falsy, the cache key is neither incremented nor checked.

      req.ip
    end

    Rack::Attack.blocklisted_response = lambda do |env|
      # Using 503 because it may make attacker think that they have successfully
      # DOSed the site. Rack::Attack returns 403 for blocklists by default
      [ 503, {}, ['Blocked']]
    end

    Rack::Attack.throttled_response = lambda do |env|
      # NB: you have access to the name and other data about the matched throttle
      #  env['rack.attack.matched'],
      #  env['rack.attack.match_type'],
      #  env['rack.attack.match_data']

      # Using 503 because it may make attacker think that they have successfully
      # DOSed the site. Rack::Attack returns 429 for throttling by default
      [ 503, {}, ["Server Error\n"]]
    end

    ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
      puts req.inspect
    end
  end

end