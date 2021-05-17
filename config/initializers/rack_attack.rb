require "json"

rate_limit_html = File.read(Rails.root.join("public", "429.html"))

Rack::Attack.safelist("allow RSpec") { |req| Rails.env.test? }

Rack::Attack.safelist("allow webhooks") do |req|
  %w[/events/postmark].include?(req.path)
end

# Rack::Attack.safelist("allow development") { |req| Rails.env.development? }

# Limit data modification requests
Rack::Attack.throttle("unsafe/req/ip", limit: 30, period: 60.seconds) do |req|
  req.ip unless req.get?
end

Rack::Attack.throttle("authentication/ip", limit: 30, period: 1.hour) do |req|
  if req.post? &&
       %w[/users/sign_in /users/sign_up /users/password].include?(
         req.path
       )
    req.ip
  end
end

Rack::Attack.throttle("api/publishable_key", limit: 20, period: 60.seconds) do |req|
  pub_key_matcher = %r{\A/api/([^/]+)/.+}

  # Limit by publishable_key
  if !req.get? && req.path.match?(pub_key_matcher)
    req.path[pub_key_matcher, 1]
  end
end

Rack::Attack.throttled_response = lambda do |env|
  # NB: you have access to the name and other data about the matched throttle
  #  env['rack.attack.matched'],
  #  env['rack.attack.match_type'],
  #  env['rack.attack.match_data']
  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 429 for throttling by default
  # [ 503, {}, ["Server Error\n"]]
  headers = {
    "Content-Type" => "text/html", "Content-Length" => rate_limit_html.size.to_s
  }
  [429, headers, [rate_limit_html]]
end

ActiveSupport::Notifications.subscribe(
  "rack.attack"
) do |name, start, finish, request_id, payload|
  req = payload[:request]
  Rails.logger.info "Throttled #{
                      req.env["rack.attack.match_discriminator"]
                    } reason: #{req.env["rack.attack.matched"]}"
end
