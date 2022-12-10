class EmptyMessageComponentPreview < ViewComponent::Preview
  # @!group Layouts

  def default
    render EmptyMessageComponent.new(title: "No contacts", body: "You currently have no contacts.")
  end

  def default_with_block
    render EmptyMessageComponent.new(title: "No contacts") do
      tag.p("You currently have no contacts.", class: "text-lg") +
      tag.button("Add contact", class: "mt-3 bg-blue-500 text-white p-3 rounded-md")
    end
  end
end
