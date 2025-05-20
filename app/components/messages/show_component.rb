# frozen_string_literal: true

class Messages::ShowComponent < ApplicationComponent
  option :message

  def from_customer?
    message.customer?
  end
end
