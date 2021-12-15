class CannedResponse < ApplicationRecord
  include TeamOwnable

  has_rich_text :content

  validates :label, presence: true
end
