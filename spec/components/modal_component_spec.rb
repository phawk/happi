require "rails_helper"

RSpec.describe ModalComponent, type: :component do
  it "renders the title and content" do
    comp = render_inline(described_class.new(title: "Hello modal")) { "Content..." }

    expect(comp.css("h3").to_html).to include("Hello modal")
    expect(comp.to_html).to include("Content...")
  end

  context "when closeable" do
    it "renders a close link" do
      comp = render_inline(described_class.new(title: "Hello modal", closeable: true, back_to: "/back")) do
        "Content..."
      end

      expect(comp.css("[aria-label='Close modal']")).not_to be_empty
    end
  end
end
