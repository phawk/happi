class MessageThread < ApplicationRecord
  belongs_to :customer
  belongs_to :team
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy
end
