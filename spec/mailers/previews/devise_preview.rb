class DevisePreview < ActionMailer::Preview
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "fake-token")
  end

  def email_changed
    Devise::Mailer.email_changed(User.first, {})
  end

  def password_change
    Devise::Mailer.password_change(User.first, {})
  end

  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, "abc123")
  end
end
