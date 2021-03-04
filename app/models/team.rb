class Team < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :customers, dependent: :destroy
  has_many :message_threads, dependent: :destroy

  validates :name, presence: true
end
