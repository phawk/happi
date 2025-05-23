require "vcr"
require "webmock"

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  c.filter_sensitive_data("OPENAI_API_KEY") do
    ENV["OPENAI_API_KEY"]
  end
  # c.debug_logger = $stderr
end
