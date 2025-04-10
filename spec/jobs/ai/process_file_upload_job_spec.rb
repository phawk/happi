require "rails_helper"

RSpec.describe Ai::ProcessFileUploadJob, type: :job do
  let(:user) { users(:pete) }
  let(:team) { teams(:acme) }
  let(:upload) do
    team.file_uploads.create!(
      user: user,
      file: fixture_file_upload("spec/fixtures/files/test.pdf", "application/pdf")
    )
  end

  describe "#perform" do
    it "processes the file upload" do
      subject.perform(upload)
      expect(upload.reload.summary).to include("Please accept this letter as my authority to provide Pete Hawkins (at FV) with any information")
    end
  end
end
