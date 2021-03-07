class MessageThread < ApplicationRecord
  STATUS = %w[open waiting closed]
  OPEN_STATUS = %w[open waiting]

  belongs_to :customer
  belongs_to :team
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy

  scope :with_open_status, -> { where(status: OPEN_STATUS) }
  scope :without_open_status, -> { where.not(status: OPEN_STATUS) }
  scope :most_recent, -> { order(updated_at: :desc) }

  validates :status, presence: true, inclusion: { in: STATUS }

  def open?
    status == "open"
  end
end
