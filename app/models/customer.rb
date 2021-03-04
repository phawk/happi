class Customer < ApplicationRecord
  has_person_name

  belongs_to :team
  has_many :message_threads, dependent: :destroy
  validates :first_name, :last_name, :email, presence: true
end
