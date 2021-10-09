# frozen_string_literal: true

class EmptyMessageComponent < ViewComponent::Base
  attr_reader :title, :body

  def initialize(title:, body: nil)
    super
    @title = title
    @body = body
  end
end
