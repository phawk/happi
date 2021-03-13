# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  def initialize(title:, closeable: false, back_to: nil)
    @title = title
    @closeable = closeable
    @back_to = back_to
  end
end
