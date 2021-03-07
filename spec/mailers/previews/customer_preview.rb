class CustomerPreview < ActionMailer::Preview
  def new_reply
    CustomerMailer.new_reply(Message.first)
  end
end
