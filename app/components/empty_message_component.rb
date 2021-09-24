# frozen_string_literal: true

class EmptyMessageComponent < ViewComponent::Base
  def initialize(title:, body:)
    super
    @title = title
    @body = body
  end
end
