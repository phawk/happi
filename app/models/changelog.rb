class Changelog < ApplicationRecord
  has_rich_text :content

  scope :ordered, -> { order(released: :desc) }
end
