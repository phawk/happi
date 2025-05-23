require "rails_helper"

RSpec.describe UploadStatusComponent, type: :component do
  it "renders processed" do
    file_upload = OpenStruct.new(
      processed?: true,
      vectorizing?: false,
      processing?: false,
      status: "processed"
    )
    render_inline(described_class.new(file_upload: file_upload))
    expect(page).to have_text("Processed & Searchable")
  end

  it "renders vectorizing" do
    file_upload = OpenStruct.new(
      processed?: false,
      vectorizing?: true,
      processing?: false,
      status: "vectorizing"
    )
    render_inline(described_class.new(file_upload: file_upload))
    expect(page).to have_text("Vectorizing...")
  end

  it "renders processing" do
    file_upload = OpenStruct.new(
      processed?: false,
      vectorizing?: false,
      processing?: true,
      status: "processing"
    )
    render_inline(described_class.new(file_upload: file_upload))
    expect(page).to have_text("Processing...")
  end
end
