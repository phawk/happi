class TeamPreview < ActionMailer::Preview
  def welcome
    TeamMailer.welcome(Team.first)
  end

  def new_message
    TeamMailer.new_message(Message.first)
  end

  def verified
    TeamMailer.verified(Team.first)
  end

  def not_found
    TeamMailer.not_found(Customer.first)
  end
end
