# @label Basic Badge
class BadgeComponentPreview < ViewComponent::Preview
  # @!group Styles

  # Default badge
  # ----------------
  # Used to display a badge.
  #
  # @param content text
  def default(content: "My badge")
    render(BadgeComponent.new(style: :normal)) do
      content
    end
  end

  # Important badge
  # ----------------
  # Used to display an important badge.
  #
  # @param content text
  def important(content: "My important badge")
    render(BadgeComponent.new(style: :important)) do
      content
    end
  end
end
