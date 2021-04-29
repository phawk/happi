class AdminPreview < ActionMailer::Preview
  def notification
    AdminMailer.notification("New beta signup", "test@hey.com just signed up for the beta")
  end
end
