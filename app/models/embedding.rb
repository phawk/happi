class Embedding < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :object, polymorphic: true

  validates :vectors, presence: true
  validates :content, presence: true
end
