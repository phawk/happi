class MessageThread < ApplicationRecord
  STATUS = %w[open closed]

  belongs_to :customer
  belongs_to :team
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy

  scope :with_open_status, -> { where(status: "open") }
end
