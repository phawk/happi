require "rails_helper"

RSpec.describe BadgeComponent, type: :component do
  it "renders a badge" do
    render_inline(described_class.new) { "Badger" }

    expect(rendered_component).to include("Badger")
  end

  it "is purple when important" do
    render_inline(described_class.new(style: :important)) { "Badger" }

    expect(rendered_component).to include("purple")
  end
end
