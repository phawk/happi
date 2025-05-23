require "rails_helper"

RSpec.describe KnowledgeBase::FileUpload, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:embeddings).dependent(:destroy) }
  it { is_expected.to have_one_attached(:file) }
  it { is_expected.to validate_presence_of(:file) }
end
