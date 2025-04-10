require "dry-initializer"
require "dry/monads"

class ApplicationService
  extend Dry::Initializer
  include Dry::Monads[:result]
end
