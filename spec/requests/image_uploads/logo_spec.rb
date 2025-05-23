require 'rails_helper'

RSpec.describe ImageUploads::LogoController, type: :request do
  let(:user) { users(:pete) }
  let(:message) { messages(:acme_alex_stripe_msg_1) }
  let(:logo_path) { Rails.root.join("spec", "fixtures", "files", "happi-h.png") }

  describe "#show" do
    context "when the lead_message ID is valid" do
      context "and the team has a logo uploaded" do
        before do
          user.team.logo.attach(io: File.open(logo_path), filename: "happi-h.png")
        end

        it "renders the logo and tracks an open" do
          expect do
            get image_uploads_logo_path(message.to_gid_param)
            expect(response).to have_http_status(:success)
            expect(message.reload.status).to eq("opened")
          end.to change(MessageStatusUpdate, :count).by(1)
        end
      end

      context "and the team doesn't have logo uploaded" do
        it "returns a 404" do
          get image_uploads_logo_path(message.to_gid_param)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when the lead message ID is invalid" do
      it "returns a 404" do
        get image_uploads_logo_path("blahhh")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
