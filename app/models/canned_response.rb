class CannedResponse < ApplicationRecord
  belongs_to :team

  has_rich_text :content

  validates :label, presence: true
end
