require 'rails_helper'

RSpec.describe "KnowledgeBases", type: :request do
  let(:user) { users(:pete) }
  let(:team) { teams(:acme) }

  before do
    sign_in user
  end

  describe "#index" do
    context "when there are file uploads" do
      it "assigns the team's file uploads to @file_uploads" do
        team.file_uploads.create!(
          user: user,
          file: fixture_file_upload("spec/fixtures/files/test.pdf", "application/pdf")
        )
        get knowledge_base_index_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("test.pdf")
      end
    end

    context "when there are no file uploads" do
      it "returns http success and renders the index template" do
        get knowledge_base_index_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#create" do
    let(:valid_attributes) do
      {
        knowledge_base_file_upload: {
          file: fixture_file_upload("spec/fixtures/files/test.pdf", "application/pdf")
        }
      }
    end

    let(:invalid_attributes) do
      {
        knowledge_base_file_upload: {
          file: nil # Missing file
        }
      }
    end

    context "with valid parameters" do
      it "creates a new KnowledgeBase::FileUpload" do
        expect {
          post knowledge_base_index_path, params: valid_attributes
        }.to change(KnowledgeBase::FileUpload, :count).by(1)
      end

      it "assigns the file upload to the current user and team" do
        post knowledge_base_index_path, params: valid_attributes
        file_upload = KnowledgeBase::FileUpload.last
        expect(file_upload.user).to eq(user)
        expect(file_upload.team).to eq(team)
      end

      it "enqueues Ai::ProcessFileUploadJob" do
        expect {
          post knowledge_base_index_path, params: valid_attributes
        }.to have_enqueued_job(Ai::ProcessFileUploadJob).with(KnowledgeBase::FileUpload.last)
      end

      it "redirects to the knowledge base index" do
        post knowledge_base_index_path, params: valid_attributes
        expect(response).to redirect_to(knowledge_base_index_path)
        expect(flash[:notice]).to eq("File uploaded successfully and is being processed.")
      end
    end

    context "with invalid parameters" do
      it "does not create a new KnowledgeBase::FileUpload" do
        expect {
          post knowledge_base_index_path, params: invalid_attributes
        }.to_not change(KnowledgeBase::FileUpload, :count)
      end

      it "responds with unprocessable_entity status" do
        post knowledge_base_index_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
