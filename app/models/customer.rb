class Customer < ApplicationRecord
  has_person_name

  belongs_to :team
  has_many :message_threads, dependent: :destroy
end
