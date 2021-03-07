class MessageThread < ApplicationRecord
  STATUS = %w[open closed]

  belongs_to :customer
  belongs_to :team
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy

  scope :with_open_status, -> { where(status: "open") }
  scope :without_open_status, -> { where.not(status: "open") }
  scope :most_recent, -> { order(updated_at: :desc) }

  def open?
    status == "open"
  end
end
