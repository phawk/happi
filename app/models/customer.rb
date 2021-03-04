class Customer < ApplicationRecord
  belongs_to :team
  has_many :message_threads, dependent: :destroy
end
