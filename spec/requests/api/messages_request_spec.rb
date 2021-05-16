require "rails_helper"

RSpec.describe Api::MessagesController, type: :request do
  describe "POST /api/:key/messages" do
    it "creates a new message when customer JWT is valid"
    it "returns an error when customer JWT is invalid"
  end
end
