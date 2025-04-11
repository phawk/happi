class ReplyStatistic < ApplicationRecord
  belongs_to :message_thread
  belongs_to :team
end
