# frozen_string_literal: true

class MessageStatusIconComponent < ViewComponent::Base
  attr_reader :message

  def initialize(message:)
    @message = message
  end

  def inbound?
    message.customer?
  end
end
