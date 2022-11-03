require "rails_helper"

RSpec.describe "Rendering message partial", type: :view do
  let(:team) { teams(:acme) }
  let(:message) { messages(:acme_alex_password_reset_msg_1) }

  it "renders without issues" do
    render partial: "messages/message", locals: { message: message }
    expect(rendered).to include("Hello Alex, I have reset your password")
  end

  it "renders without when the team has internal_access" do
    team.update(access_level: "internal")
    render partial: "messages/message", locals: { message: message }
    expect(rendered).to include("Hello Alex, I have reset your password")
  end
end
