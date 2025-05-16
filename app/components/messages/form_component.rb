# frozen_string_literal: true

class Messages::FormComponent < ApplicationComponent
  option :message_thread
  option :message
  option :current_user
  option :current_team
  option :canned_responses, default: -> { [] }
  option :ai_status, default: -> { nil }
  option :draft_ai_reply, default: -> { false }

  alias_method :draft_ai_reply?, :draft_ai_reply
end
