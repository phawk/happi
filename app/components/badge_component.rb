# frozen_string_literal: true

class BadgeComponent < ViewComponent::Base
  def initialize(style: :normal)
    super
    @style = style
  end

  def class_names
    case @style
    when :important
      "bg-purple-100 text-purple-800"
    when :success
      "bg-green-100 text-green-800"
    else
      "bg-gray-100 text-gray-600"
    end
  end
end
