# frozen_string_literal: true

class Messages::FormComponent < ApplicationComponent
  option :message_thread
  option :message
  option :emails_to_send_from, default: -> { [] }
  option :canned_responses, default: -> { [] }
  option :ai_status, default: -> { nil }
  option :draft_ai_reply, default: -> { false }
  option :can_send_messages, default: -> { true }

  alias_method :draft_ai_reply?, :draft_ai_reply
  alias_method :can_send_messages?, :can_send_messages
end
