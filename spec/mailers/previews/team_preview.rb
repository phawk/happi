class TeamPreview < ActionMailer::Preview
  def new_message
    TeamMailer.new_message(Message.find(480))
  end

  def new_internal_note
    TeamMailer.new_internal_note(Message.find(480))
  end

  def verified
    TeamMailer.verified(Team.first)
  end

  def not_found
    TeamMailer.not_found(Customer.first)
  end

  def email_awaiting_approval
    TeamMailer.email_awaiting_approval(Team.first, "help@acme.com")
  end
end
