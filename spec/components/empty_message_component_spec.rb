require "rails_helper"

RSpec.describe EmptyMessageComponent, type: :component do
  it "renders title and body" do
    comp = render_inline(described_class.new(title: "No messages", body: "You have not received a message yet!"))

    expect(comp.css("h3").text).to include("No messages")
    expect(comp.css("p").text).to include("You have not received a message yet!")
  end
end
