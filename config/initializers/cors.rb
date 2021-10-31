Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"
    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head]
  end

  allow do
    origins "http://localhost:4567",
      /.happi.team.co\z/,
      /.happi.test\z/
    resource "/auth/check",
      headers: :any,
      credentials: true,
      methods: %i[get]
  end
end
