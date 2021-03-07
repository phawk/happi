class ApplicationMailbox < ActionMailbox::Base
  THREADS_MATCHER = %r{(.+)@in.happi.team}
  # routing /something/i => :somewhere
  # routing :all => :threads
  routing THREADS_MATCHER => :threads
end
