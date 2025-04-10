module JobsHelper
  include ActiveJob::TestHelper
end

RSpec.configure do |config|
  config.include JobsHelper
  config.before(:each) { clear_enqueued_jobs }
end
