class ApplicationMailbox < ActionMailbox::Base
  # Routing all allows custom email addresses to be used.
  routing :all => :threads
  # routing THREADS_MATCHER => :threads
end
