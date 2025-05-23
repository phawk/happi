require "dry-initializer"

class ApplicationComponent < ViewComponent::Base
  extend Dry::Initializer

  delegate :avatar_tag, to: :helpers
  delegate :datetime, to: :helpers
  delegate :rich_text_area_tag, to: :helpers
end
