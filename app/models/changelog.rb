class Changelog < ApplicationRecord
  has_rich_text :content

  scope :ordered, -> { order(released: :desc) }
  scope :published, -> { where.not(released: nil) }
end
