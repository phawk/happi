require "rails_helper"

RSpec.describe BadgeComponent, type: :component do
  it "renders a badge" do
    comp = render_inline(described_class.new) { "Badger" }

    expect(comp.to_html).to include("Badger")
  end

  it "is purple when important" do
    comp = render_inline(described_class.new(style: :important)) { "Badger" }

    expect(comp.to_html).to include("purple")
  end
end
