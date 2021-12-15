class MessageThread < ApplicationRecord
  STATUS = %w[open waiting closed archived]
  ASSIGNABLE_STATUS = %w[open waiting closed]
  OPEN_STATUS = %w[open waiting]
  CLOSED_STATUS = %w[closed]

  include TeamOwnable

  after_create_commit { broadcast_prepend_to(turbo_channel, target: "open_message_threads") }
  after_update_commit { broadcast_replace_to(turbo_channel) }
  after_destroy_commit { broadcast_remove_to(turbo_channel) }

  belongs_to :customer
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy

  scope :with_open_status, -> { where(status: OPEN_STATUS) }
  scope :without_open_status, -> { where(status: CLOSED_STATUS) }
  scope :without_archived, -> { where.not(status: "archived") }
  scope :most_recent, -> { order(updated_at: :desc) }

  validates :status, presence: true, inclusion: { in: STATUS }
  validates :subject, presence: true

  def open?
    status == "open"
  end

  def reply_to_address
    return reply_to if reply_to.present?
    team.default_mailbox
  end

  def turbo_channel
    "team_#{team_id}_threads"
  end

  def archive!
    update(status: "archived")
  end

  def previous_threads
    MessageThread.without_archived \
      .where(
        "customer_id = :customer_id AND created_at < :created_at",
        customer_id: customer_id,
        created_at: created_at - 10.seconds
      )
      .order(created_at: :desc)
  end

  def previous_threads?
    previous_threads.any?
  end

  def merge_with_previous!
    previous_thread = previous_threads.first
    return if previous_thread.nil?
    messages.update_all(message_thread_id: previous_thread.id) # rubocop:disable Rails/SkipsModelValidations
    destroy
    previous_thread
  end
end
