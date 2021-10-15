class TeamPreview < ActionMailer::Preview
  def new_message
    TeamMailer.new_message(Message.find(480))
  end

  def verified
    TeamMailer.verified(Team.first)
  end

  def not_found
    TeamMailer.not_found(Customer.first)
  end
end
