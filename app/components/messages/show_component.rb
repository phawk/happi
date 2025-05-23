# frozen_string_literal: true

class Messages::ShowComponent < ApplicationComponent
  option :message

  delegate :internal?, to: :message

  def from_customer?
    message.customer?
  end
end
