require "rails_helper"

RSpec.describe Embedding, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:object) }
  it { is_expected.to have_db_column(:vectors).of_type(:vector) }
  it { is_expected.to have_db_column(:content).of_type(:text) }
end
