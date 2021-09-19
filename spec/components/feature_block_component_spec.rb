require "rails_helper"

RSpec.describe FeatureBlockComponent, type: :component do
  it "renders a title, content and image" do
    comp = render_inline(described_class.new(title: "Awesome feature")) do |c|
      c.image { "my-image.png" }
      c.text { "This is so cool!" }
    end

    expect(comp.css("h3").to_html).to include("Awesome feature")
    expect(comp.to_html).to include("my-image.png")
    expect(comp.to_html).to include("This is so cool!")
  end
end
